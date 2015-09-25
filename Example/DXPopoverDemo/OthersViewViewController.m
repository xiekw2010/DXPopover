//
//  OthersViewViewController.m
//  DXPopoverDemo
//
//  Created by xiekw on 11/21/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "OthersViewViewController.h"
#import "DXPopover.h"

@interface OthersViewViewController () {
    CGRect _brownViewOriginRect;
}

@property (weak, nonatomic) IBOutlet UIButton *topLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *topRightBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleLeftBtn;

@property (nonatomic, strong) UIView *outsideView;
@property (nonatomic, strong) UIView *innerView;

@end

@implementation OthersViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.outsideView = [[UIView alloc] initWithFrame:CGRectMake(180, 120, 120, 250)];
    self.outsideView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.outsideView];

    _brownViewOriginRect = CGRectMake(10, 10, 100, 100);
    self.innerView = [[UIView alloc] initWithFrame:_brownViewOriginRect];
    self.innerView.backgroundColor = [UIColor brownColor];
    [self.outsideView addSubview:self.innerView];
}

// Show an imageView
- (IBAction)topLeft:(id)sender {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageV.image = [UIImage imageNamed:@"ig12.jpg"];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:sender withContentView:imageV];
}

// Show an label
- (IBAction)topRight:(id)sender {
    DXPopover *popover = [DXPopover popover];
    popover.backgroundColor = [UIColor purpleColor];
    [popover showAtView:sender
               withText:[[NSAttributedString alloc] initWithString:@"jkjljdalkjdkljalfjklaj"]];
}

// show an seg
- (IBAction)bottomLeft:(id)sender {
    UISegmentedControl *switcher = [[UISegmentedControl alloc] initWithItems:@[ @"You", @"Me" ]];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:sender withContentView:switcher inView:self.view];
}

// show an xibfile
- (IBAction)middleLeft:(id)sender {
    //拿出xib视图
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"XibFile" owner:nil options:nil];
    UIView *appview=[apparray firstObject];
    
    
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:sender withContentView:appview];
    
}

// Note: Here if you don't give the position down, then it will show on up, because the atView's
// distance from containerViews' top edge is larger than the distance from the containerView's
// bottom edge.
- (IBAction)middle:(id)sender {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    textLabel.text = @"I am middle now";
    textLabel.backgroundColor = [UIColor whiteColor];

    DXPopover *popover = [DXPopover popover];
    [popover showAtView:sender
         popoverPostion:DXPopoverPositionDown
        withContentView:textLabel
                 inView:self.tabBarController.view];
}

// Show a view from other coordinator system's view, and give it back when popover dismiss
- (IBAction)bottomRight:(id)sender {
    UIView *switcher = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    switcher.backgroundColor = [UIColor redColor];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:sender withContentView:self.innerView inView:self.view];
    popover.didDismissHandler = ^{
        self.innerView.layer.cornerRadius = 0.0;
        self.innerView.frame = _brownViewOriginRect;
        [self.outsideView addSubview:self.innerView];
    };
}

@end
