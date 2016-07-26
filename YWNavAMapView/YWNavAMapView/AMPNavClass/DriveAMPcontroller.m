//
//  DriveAMPcontroller.m
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/22.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "DriveAMPcontroller.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import "DriveNaviViewController.h"
#import "SpeechSynthesizer.h" //语音播报
@interface DriveAMPcontroller ()<MAMapViewDelegate,AMapNaviDriveManagerDelegate,DriveNaviViewControllerDelegate>
{
         MAMapView                  *_mapView;
         AMapNaviDriveManager       *_driveManager;
}
@end
/*
  主要采用高德导航地图里面的快速导航,不足之处，欢迎大家批评指正。

 */
@implementation DriveAMPcontroller

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_mapView setShowsUserLocation:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    [self addPointAnnotation];//添加测试标注
    [self initDriveManager];
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
- (void)initDriveManager
{
    if (_driveManager == nil)
    {
       _driveManager = [[AMapNaviDriveManager alloc] init];
     [_driveManager setDelegate:self];
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
    
    
    
    if ([ view isKindOfClass:[ MAAnnotationView class]])
    {
        //带起点的导航
        AMapNaviPoint *endPoint=[[ AMapNaviPoint alloc] init];
        endPoint=[AMapNaviPoint locationWithLatitude:view.annotation.coordinate.latitude
                                           longitude:view.annotation.coordinate.longitude];
        AMapNaviPoint *startPoint=[[ AMapNaviPoint alloc] init];
        startPoint=[AMapNaviPoint locationWithLatitude:_coordinate.latitude
                                             longitude:_coordinate.longitude];
        BOOL success=  [_driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyFastestTime];
        if (!success)
        {
          [[[UIAlertView  alloc] initWithTitle:@"温馨提示" message:@"导航规划失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }

        
    }
    
  }

/**
 *  驾车路径规划成功后的回调函数
 */
#pragma mark --private Method--开始导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    

    //这里面的UI自己可以修改官方里面都有
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    //将driveView添加到AMapNaviDriveManager中
    [_driveManager addDataRepresentative:driveVC.driveView];
    [self.navigationController pushViewController:driveVC animated:NO];
    [_driveManager startGPSNavi];

}

#pragma mark --private Method--
/**
 *  发生错误时,会调用代理的此方法
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error{
    
    
}

/**
 *  驾车路径规划失败后的回调函数
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    
}

/**
 *  启动导航后回调函数
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode{
    
    
}

/**
 *  出现偏航需要重新计算路径时的回调函数
 */
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager{
    
    
}

/**
 *  前方遇到拥堵需要重新计算路径时的回调函数
 */
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager{
    
    
}

/**
 *  导航到达某个途经点的回调函数
 *
 *  @param wayPointIndex 到达途径点的编号，标号从1开始
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex{
    
}

/**
 *  导航播报信息回调函数
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    
    //[[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];

    
}


/**
 *  模拟导航到达目的地停止导航后的回调函数
 */
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    
}

/**
 *  导航到达目的地后的回调函数
 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager{
   
    
}
#pragma mark --private Method--点击关闭导航
- (void)driveNaviViewCloseButtonClicked{
    
    [_driveManager stopNavi];
    
    //停止语音
  //  [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
