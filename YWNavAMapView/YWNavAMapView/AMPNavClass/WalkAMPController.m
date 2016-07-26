//
//  WalkAMPController.m
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/22.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "WalkAMPController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import "WalkNaviViewController.h"
@interface WalkAMPController ()<MAMapViewDelegate,AMapNaviWalkManagerDelegate>
{
    AMapNaviWalkManager    *_walkManager;
    MAMapView              *_mapView;
}
@end

@implementation WalkAMPController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_mapView setShowsUserLocation:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    [self addPointAnnotation];//添加测试标注
    [self initwalkManagerr];
}
- (void)initMapView
{
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [_mapView setDelegate:self];
        [self.view addSubview:_mapView];
    }
}
#pragma mark --private Method--添加测试标注，可根据需求自己改动
-(void)addPointAnnotation{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(39.59, 116.10)];
    [_mapView addAnnotation:annotation];
}
- (void)initwalkManagerr
{
    if (_walkManager == nil)
    {
        _walkManager = [[AMapNaviWalkManager alloc] init];
        [_walkManager setDelegate:self];
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    
    
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"QuickStartAnnotationView";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.draggable = NO;
        
        return annotationView;
    }
    
    return nil;
}
#pragma mark --private Method--点击大头针开始导航
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    

    //带起点的导航
    AMapNaviPoint *endPoint=[[ AMapNaviPoint alloc] init];
    endPoint=[AMapNaviPoint locationWithLatitude:view.annotation.coordinate.latitude
                                       longitude:view.annotation.coordinate.longitude];
    AMapNaviPoint *startPoint=[[ AMapNaviPoint alloc] init];
    startPoint=[AMapNaviPoint locationWithLatitude:_coordinate.latitude
                                         longitude:_coordinate.longitude];

   BOOL success=  [_walkManager calculateWalkRouteWithStartPoints:@[startPoint] endPoints:@[endPoint]];
  if (!success)
     {
        [[[UIAlertView  alloc] initWithTitle:@"温馨提示" message:@"导航规划失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
     }
}
/**
 *  发生错误时,会调用代理的此方法
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error{
    
    
}

/**
 *  步行路径规划成功后的回调函数
 */
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    
    
    WalkNaviViewController *controller=[[WalkNaviViewController alloc] init];
    [controller setDelegate:self];
    //将walkView添加到_walkManager中
    [_walkManager addDataRepresentative:controller.walkView];

    
    [self.navigationController pushViewController:controller animated:YES];
    
}
/**
 *  步行路径规划失败后的回调函数
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error{
    
    
}

/**
 *  启动导航后回调函数
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager didStartNavi:(AMapNaviMode)naviMode{
    
    
}

/**
 *  出现偏航需要重新计算路径时的回调函数
 */
- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager{
    
    
}

/**
 *  导航播报信息回调函数
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    
    
}

/**
 *  模拟导航到达目的地停止导航后的回调函数
 */
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager{
    
    
}

/**
 *  导航到达目的地后的回调函数
 */
- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager{
    
    
}
#pragma mark --private Method--关闭地图
- (void)WalkNaviViewCloseButtonClicked{
    
    [_walkManager stopNavi];
    //停止语音
   // [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
