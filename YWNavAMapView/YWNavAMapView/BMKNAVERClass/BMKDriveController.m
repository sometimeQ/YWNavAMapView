//
//  BMKDriveController.m
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/25.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "BMKDriveController.h"
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
@interface BMKDriveController ()<BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>

@end

@implementation BMKDriveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"驾车导航";
    [self.view setBackgroundColor:[ UIColor whiteColor]];
    [self startNavi];
    // Do any additional setup after loading the view.
}
#pragma mark 导航
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init]; //
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

#pragma mark - BNNaviUIManagerDelegate

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

- (void)onExitexitDeclarationUI:(NSDictionary*)extraInfo{
    
    
}

- (void)dealloc{
    
    [BNCoreServices   ReleaseInstance];
    NSLog(@"%s",__func__);
    
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
