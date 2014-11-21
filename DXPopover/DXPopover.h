//
//  DXPopover.h
//
//  Created by xiekw on 11/14/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DXPopoverPosition) {
    DXPopoverPositionUp = 1,
    DXPopoverPositionDown,
};

typedef NS_ENUM(NSUInteger, DXPopoverMaskType) {
    DXPopoverMaskTypeBlack,
    DXPopoverMaskTypeNone,
};


@interface DXPopover : UIView

+ (instancetype)popover;

@property (nonatomic, assign, readonly) DXPopoverPosition popoverPosition;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat animationIn;
@property (nonatomic, assign) CGFloat animationOut;
@property (nonatomic, assign) BOOL animationSpring;
@property (nonatomic, assign) DXPopoverMaskType maskType;

/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow and atView. Note: this value is invalid when popover show using the atPoint API
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;


/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;


@property (nonatomic, copy) dispatch_block_t didShowHandler;
@property (nonatomic, copy) dispatch_block_t didDimissHandler;

/**
 *  Show API
 *
 *  @param point         the point in the container coordinator system.
 *  @param position      stay up or stay down from the showAtPoint
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtPoint:(CGPoint)point popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param position      stay up or stay down from the atView, if up or down size is not enough for contentView, then it will be set correctly auto.
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain 
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, using application's keyWindow as containerView, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView;

- (void)dismiss;


@end
