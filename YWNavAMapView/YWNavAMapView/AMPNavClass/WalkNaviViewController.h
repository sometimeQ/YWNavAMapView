//
//  WalkNaviViewController.h
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/22.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@protocol WalkNaviViewControllerDelegate <NSObject>

- (void)WalkNaviViewCloseButtonClicked;

@end
@interface WalkNaviViewController : UIViewController
@property (nonatomic, weak) id <WalkNaviViewControllerDelegate> delegate;

@property (nonatomic, strong) AMapNaviWalkView *walkView;

@end
