//
//  DXPopover.m
//
//  Created by xiekw on 11/14/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "DXPopover.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@interface DXPopover ()

@property (nonatomic, strong) UIControl *blackOverlay;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign, readwrite) DXPopoverPosition popoverPosition;
@property (nonatomic, assign) CGPoint arrowShowPoint;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, assign) CGRect contentViewFrame; //the contentview frame in the containerView coordinator

@end

@implementation DXPopover

+ (instancetype)popover
{
    return [[DXPopover alloc] init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.arrowSize = CGSizeMake(11.0, 9.0);
        self.cornerRadius = 7.0;
        self.backgroundColor = [UIColor clearColor];
        self.animationIn = 0.4;
        self.animationOut = 0.3;
        self.animationSpring = YES;
        self.sideEdge = 10.0;
        self.maskType = DXPopoverMaskTypeBlack;
        self.betweenAtViewAndArrowHeight = 4.0;
        self.applyShadow = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (void)setApplyShadow:(BOOL)applyShadow
{
    _applyShadow = applyShadow;
    if (_applyShadow) {
        self.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2.0;
    }else {
        self.layer.shadowColor = nil;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowRadius = 0.0;
    }
}

- (void)_setup
{
    CGRect frame = self.contentViewFrame;
    
    CGFloat frameMidx = self.arrowShowPoint.x-CGRectGetWidth(frame)*0.5;
    frame.origin.x = frameMidx;
    
    //we don't need the edge now
    CGFloat sideEdge = 0.0;
    if (CGRectGetWidth(frame)<CGRectGetWidth(self.containerView.frame)) {
        sideEdge = self.sideEdge;
    }
    
    //righter the edge
    CGFloat outerSideEdge = CGRectGetMaxX(frame)-CGRectGetWidth(self.containerView.bounds);
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge+sideEdge);
    }else {
        if (CGRectGetMinX(frame)<0) {
            frame.origin.x += abs(CGRectGetMinX(frame))+sideEdge;
        }
    }
    
    
    self.frame = frame;

    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];

    CGPoint anchorPoint;
    switch (self.popoverPosition) {
        case DXPopoverPositionDown: {
            frame.origin.y = self.arrowShowPoint.y;
            anchorPoint = CGPointMake(arrowPoint.x/CGRectGetWidth(frame), 0);
        }
            break;
        case DXPopoverPositionUp: {
            frame.origin.y = self.arrowShowPoint.y - CGRectGetHeight(frame) - self.arrowSize.height;
            anchorPoint = CGPointMake(arrowPoint.x/CGRectGetWidth(frame), 1);
        }
            break;
    }
    CGPoint DX_lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    self.layer.position = CGPointMake(self.layer.position.x+(anchorPoint.x-DX_lastAnchor.x)*self.layer.bounds.size.width, self.layer.position.y+(anchorPoint.y-DX_lastAnchor.y)*self.layer.bounds.size.height);\

    frame.size.height += self.arrowSize.height;
    self.frame = frame;
}


- (void)showAtPoint:(CGPoint)point popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView
{
    NSAssert((CGRectGetWidth(contentView.bounds)>0&&CGRectGetHeight(contentView.bounds)>0), @"DXPopover contentView bounds.size should not be zero");
    NSAssert((CGRectGetWidth(containerView.bounds)>0&&CGRectGetHeight(containerView.bounds)>0), @"DXPopover containerView bounds.size should not be zero");
    NSAssert(CGRectGetWidth(containerView.bounds)>=CGRectGetWidth(contentView.bounds), @"DXPopover containerView width should be wider than contentView width");
    
    if (!self.blackOverlay) {
        self.blackOverlay = [[UIControl alloc] init];
        self.blackOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    self.blackOverlay.frame = containerView.bounds;
    UIColor *maskColor;
    switch (self.maskType) {
        case DXPopoverMaskTypeBlack:
            maskColor = [UIColor colorWithWhite:0.0 alpha:0.2];
            break;
        case DXPopoverMaskTypeNone:
            maskColor = [UIColor clearColor];
            break;
        default:
            break;
    }
    
    self.blackOverlay.backgroundColor = maskColor;

    
    [containerView addSubview:self.blackOverlay];
    [self.blackOverlay addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.containerView = containerView;
    self.contentView = contentView;
    self.contentView.layer.cornerRadius = self.cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.popoverPosition = position;
    self.arrowShowPoint = point;
    self.contentViewFrame = [containerView convertRect:contentView.frame toView:containerView];
    
    [self show];
}

- (void)showAtView:(UIView *)atView popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView
{
    CGFloat betweenArrowAndAtView = self.betweenAtViewAndArrowHeight;
    CGFloat contentViewHeight = CGRectGetHeight(contentView.bounds);
    CGRect atViewFrame = [containerView convertRect:atView.frame toView:containerView];
    
    BOOL upCanContain = CGRectGetMinY(atViewFrame) >= contentViewHeight+betweenArrowAndAtView;
    BOOL downCanContain = (CGRectGetHeight(containerView.bounds) - (CGRectGetMaxY(atViewFrame)+betweenArrowAndAtView)) >= contentViewHeight;
    NSAssert((upCanContain||downCanContain), @"DXPopover no place for the popover show, check atView frame %@ check contentView bounds %@ and containerView's bounds %@", NSStringFromCGRect(atViewFrame), NSStringFromCGRect(contentView.bounds), NSStringFromCGRect(containerView.bounds));
    
    
    CGPoint atPoint = CGPointMake(CGRectGetMidX(atViewFrame), 0);
    DXPopoverPosition dxP;
    if (upCanContain) {
        dxP = DXPopoverPositionUp;
        atPoint.y = CGRectGetMinY(atViewFrame) - betweenArrowAndAtView;
    }else {
        dxP = DXPopoverPositionDown;
        atPoint.y = CGRectGetMaxY(atViewFrame) + betweenArrowAndAtView;
    }
    
    // if they are all yes then it shows in the bigger container
    if (upCanContain && downCanContain) {
        CGFloat upHeight = CGRectGetMinY(atViewFrame);
        CGFloat downHeight = CGRectGetHeight(containerView.bounds)-CGRectGetMaxY(atViewFrame);
        BOOL useUp = upHeight > downHeight;
        
        //except you set outsider
        if (position!=0) {
            useUp = position == DXPopoverPositionUp ? YES : NO;
        }
        if (useUp) {
            dxP = DXPopoverPositionUp;
            atPoint.y = CGRectGetMinY(atViewFrame) - betweenArrowAndAtView;
        }else {
            dxP = DXPopoverPositionDown;
            atPoint.y = CGRectGetMaxY(atViewFrame) + betweenArrowAndAtView;
        }
    }

    [self showAtPoint:atPoint popoverPostion:dxP withContentView:contentView inView:containerView];
}


- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView
{
    [self showAtView:atView popoverPostion:0 withContentView:contentView inView:containerView];
}

- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView
{
    [self showAtView:atView withContentView:contentView inView:[UIApplication sharedApplication].keyWindow];
}

- (void)show
{
    [self setNeedsDisplay];
    
    CGRect contentViewFrame = self.contentViewFrame;
    switch (self.popoverPosition) {
        case DXPopoverPositionUp:
            contentViewFrame.origin.y = 0.0;
            break;
        case DXPopoverPositionDown:
            contentViewFrame.origin.y = self.arrowSize.height;
            break;
    }
    
    self.contentView.frame = contentViewFrame;
    [self addSubview:self.contentView];
    [self.containerView addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    if (self.animationSpring) {
        [UIView animateWithDuration:self.animationIn delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.didShowHandler) {
                    self.didShowHandler();
                }
            }
        }];
    }else {
        [UIView animateWithDuration:self.animationIn delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.didShowHandler) {
                    self.didShowHandler();
                }
            }
        }];
    }
}

- (void)dismiss
{
    if (self.superview) {
        [UIView animateWithDuration:self.animationOut delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.contentView removeFromSuperview];
                [self.blackOverlay removeFromSuperview];
                [self removeFromSuperview];
                if (self.didDismissHandler) {
                    self.didDismissHandler();
                }
            }
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    UIColor *contentColor = self.contentView.backgroundColor ? : [UIColor whiteColor];
    //the point in the ourself view coordinator
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    
    switch (self.popoverPosition) {
        case DXPopoverPositionDown: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x+self.arrowSize.width*0.5, self.arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, self.arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, self.arrowSize.height+self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, CGRectGetHeight(self.bounds)-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))];
            [arrow addArcWithCenter:CGPointMake(self.cornerRadius, CGRectGetHeight(self.bounds)-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, self.arrowSize.height+self.cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(self.cornerRadius, self.arrowSize.height+self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x-self.arrowSize.width*0.5, self.arrowSize.height)];
        }
            break;
        case DXPopoverPositionUp: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, CGRectGetHeight(self.bounds))];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x-self.arrowSize.width*0.5, CGRectGetHeight(self.bounds)-self.arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(self.cornerRadius, CGRectGetHeight(self.bounds)-self.arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(self.cornerRadius, CGRectGetHeight(self.bounds)-self.arrowSize.height-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, self.cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(self.cornerRadius, self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.arrowSize.height-self.cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, CGRectGetHeight(self.bounds)-self.arrowSize.height-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x+self.arrowSize.width*0.5, CGRectGetHeight(self.bounds)-self.arrowSize.height)];
        }
            
            break;
    }
    [contentColor setFill];
    [arrow fill];
}

- (void)layoutSubviews
{
    [self _setup];
}

@end
