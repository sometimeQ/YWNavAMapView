//
//  WalkNaviViewController.m
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/22.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "WalkNaviViewController.h"
#import "MoreMenuView.h"
@interface WalkNaviViewController ()<AMapNaviWalkViewDelegate, MoreMenuViewDelegate>
@property (nonatomic, strong) MoreMenuView *moreMenu;

@end

@implementation WalkNaviViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    if (self = [super init])
    {
        [self initWalkView];
        
        [self initMoreMenu];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.walkView setFrame:self.view.bounds];
    [self.view addSubview:self.walkView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)initWalkView
{
    if (self.walkView == nil)
    {
        self.walkView = [[AMapNaviWalkView alloc] init];
        self.walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.walkView setDelegate:self];
    }
}

- (void)initMoreMenu
{
    if (self.moreMenu == nil)
    {
        self.moreMenu = [[MoreMenuView alloc] init];
        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.moreMenu setDelegate:self];
    }
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        interfaceOrientation = self.interfaceOrientation;
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [self.walkView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.walkView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DriveView Delegate

/**
 *  导航界面关闭按钮点击时的回调函数
 */
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(WalkNaviViewCloseButtonClicked)])
    {
        [self.delegate WalkNaviViewCloseButtonClicked];
    }
    
}

/**
 *  导航界面更多按钮点击时的回调函数
 */
- (void)walkViewMoreButtonClicked:(AMapNaviWalkView *)walkView{
    //配置MoreMenu状态
    [self.moreMenu setTrackingMode:self.walkView.trackingMode];
    [self.moreMenu setShowNightType:self.walkView.showStandardNightType];
    
    [self.moreMenu setFrame:self.view.bounds];
    [self.view addSubview:self.moreMenu];

}

/**
 *  导航界面转向指示View点击时的回调函数
 */
- (void)walkViewTrunIndicatorViewTapped:(AMapNaviWalkView *)walkView{

    /*
     AMapNaviWalkViewShowModeCarPositionLocked = 1,  //锁车状态
     AMapNaviWalkViewShowModeOverview = 2,           //全览状态
     AMapNaviWalkViewShowModeNormal = 3,             //普通状态
     */

    if (self.walkView.showMode == AMapNaviWalkViewShowModeCarPositionLocked)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeNormal];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeNormal)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeOverview];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeOverview)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeCarPositionLocked];
    }
}

/**
 *  导航界面显示模式改变后的回调函数
 *
 *  @param showMode 显示模式
 */
- (void)walkView:(AMapNaviWalkView *)walkView didChangeShowMode:(AMapNaviWalkViewShowMode)showMode
{
    
    
}
#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked
{
    [self.moreMenu removeFromSuperview];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType
{
    [self.walkView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode
{
    [self.walkView setTrackingMode:trackingMode];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
