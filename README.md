# YWNavAMapView
高德、百度地图导航功能实现
####特别注意的是：NSLocationWhenInUseUsageDescription&& NSLocationAlwaysUsageDescription
----->高德需要任选其一就可
----->百度给出的是NSLocationAlwaysUsageDescription
----->百度导航要开启BackGround Modes中的Location Update否则会闪退程序
##高德地图
  简述：高德导航分为模拟导航和实时导航两种，两种导航都包括语音提示、停止导航、暂停或继续导航功能。通过模拟导航，用户可预先了解出行路线，直观掌握沿途每一个特别路口的交通状况，算路成功后就可在导航视图或HUD视图下开始导航。

->1环境配置&&应用授权
           工程配置在这里->http://lbs.amap.com/api/ios-navi-sdk/guide/project/
 cocoapod配置->http://lbs.amap.com/api/ios-navi-sdk/guide/pod/
  ```
  [AMapServices sharedServices].apiKey = @"483d6fcb1303a7a98b2e4370b5ff9c33";
  ```
->2
 驾车导航
```
//声明变量
  AMapNaviDriveManager      *_driveManager;
//初始化对象
- (void)initDriveManager{
    if (_driveManager == nil)  {
    _driveManager = [[AMapNaviDriveManager alloc] init];
     [_driveManager setDelegate:self];
    }
}
```


#####重点来了---------->有起始点的导航
```
/*
 *  带起点的驾车路径规划
 *
 *  @param startPoints  起点坐标.支持多个起点,起点列表的尾点为实际导航起点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @param endPoints    终点坐标.支持多个终点,终点列表的尾点为实际导航终点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @param wayPoints    途经点坐标,最多支持4个途经点.
 *  @param strategy     路径的计算策略
 *  @return 规划路径是否成功
  * @param 示例如下:
  AMapNaviPoint *endPoint=[[ AMapNaviPoint alloc] init];
  endPoint=[AMapNaviPoint locationWithLatitude:view.annotation.coordinate.latitude
                                           longitude:view.annotation.coordinate.longitude];
  AMapNaviPoint *startPoint=[[ AMapNaviPoint alloc] init];
  startPoint=[AMapNaviPoint locationWithLatitude:_coordinate.latitude
                                             longitude:_coordinate.longitude];
  BOOL success=[_driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyFastestTime];
    if (!success)
       {
          [[[UIAlertView  alloc] initWithTitle:@"温馨提示" message:@"导航规划失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
       }
```
#############---------->无起始点的导航
```
 /**
 *  不带起点的驾车路径规划
 *
 *  @param endPoints    终点坐标.支持多个终点,终点列表的尾点为实际导航终点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @param wayPoints    途经点坐标,最多支持4个途经点.
 *  @param strategy     路径的计算策略
 *  @return 规划路径是否成功
 */
- (BOOL)calculateDriveRouteWithEndPoints:(NSArray<AMapNaviPoint *> *)endPoints
                               wayPoints:(nullable NSArray<AMapNaviPoint *> *)wayPoints
                         drivingStrategy:(AMapNaviDrivingStrategy)strategy;

```
#############---------->驾车导航代理方法AMapNaviDriveManagerDelegate
```
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

#pragma mark --private Method--发生错误时,会调用代理的此方法
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
}
#pragma mark --private Method-- *驾车路径规划失败后的回调函数
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{  
}
#pragma mark --private Method-- 启动导航后回调函数
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{   
}
#pragma mark --private Method--出现偏航需要重新计算路径时的回调函数
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager{
    
}
#pragma mark --private Method-- *  导航播报信息回调函数
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    //导航播报信息回调函数
   [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}
#pragma mark --private Method--点击关闭导航
- (void)driveNaviViewCloseButtonClicked
{
    [_driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:NO];
}
```


 walk导航   
```
 ---->标注： 步行导航的方法与驾车导航的方法有很多类似之处，在这里不再参数，lZ只标注几个重要的方法
```
```
#####-->代码在这里
/**
 *  不带起点的步行路径规划
 *  @param endPoints 终点坐标.支持多个终点,终点列表的尾点为实际导航终点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @return 规划路径是否成功
 */
- (BOOL)calculateWalkRouteWithEndPoints:(NSArray<AMapNaviPoint *> *)endPoints;



/**
 *  带起点的步行路径规划
 *  @param startPoints  起点坐标.支持多个起点,起点列表的尾点为实际导航起点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @param endPoints    终点坐标.支持多个终点,终点列表的尾点为实际导航终点,其他坐标点为辅助信息,带有方向性,可有效避免算路到马路的另一侧.
 *  @return 规划路径是否成功
 */
- (BOOL)calculateWalkRouteWithStartPoints:(NSArray<AMapNaviPoint *> *)startPoints
                                endPoints:(NSArray<AMapNaviPoint *> *)endPoints;

```

##百度地图
   ######->1 SDK导入&&环境配置
```
1.下载SDK、并导入工程
2.将工程中的某个文件改成.mm结尾 ->C++
3.导入依赖库,添加“-ObjC” 标识 
4.最重要的来了—>
 Build Phases->
 Complie Sources->
 找到与TouchJson相关的文件，点击Add添加 -fno-objc-arc

```
  #####->2 导航实现
```
#####-->代码在这里
   1.初始化设置
    [BNCoreServices_Instance initServices: NAVI_TEST_APP_KEY];
    [BNCoreServices_Instance  startServicesAsyn:^{
        NSLog(@"导航启动成功");
    } fail:^{
        NSLog(@"导航启动失败");
    }];
```
```
2.在需要导航的视图中导入
  #import "BNRoutePlanModel.h"
  #import "BNCoreServices.h"
3.设置起始点->免责声明->路线规划->规划成功、开始导航
 - (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];

    //起点 
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init]; 
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = _coordinate.longitude;
    startNode.pos.y = _coordinate.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
 
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    
    //39.59, 116.10
    endNode.pos.x = 116.403875;
    endNode.pos.y =39.915168;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
    
}
```
```
#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    
    //显示导航UI
    [BNCoreServices_UI showNaviUI:BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}
//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
    [self performSelector:@selector(onExitDeclarationUI:) withObject:nil afterDelay:1];
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}
//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    [self.navigationController popViewControllerAnimated:NO];
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出电子狗页面");
    
}
```





##系统自带客户端地图导航

```
######-->具体代码在这里
// 直接调用ios自己带的apple map
MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_coordinate addressDictionary:nil]];
MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:
                                                                      CLLocationCoordinate2DMake(39.915168,116.403875) addressDictionary:nil]];//目的地的位置
toLocation.name = @"目的地";
NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
[MKMapItem openMapsWithItems:items launchOptions:options]; //打开苹果自身地图应用，并呈现特定的item

```

