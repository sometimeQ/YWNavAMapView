//
//  ViewController.m
//  YWNavAMapView
//
//  Created by NeiQuan on 16/7/21.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
//高德
#import "DriveAMPcontroller.h" //驾车导航
#import "WalkAMPController.h"//步行导航

// 百度
#import "BMKDriveController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
{
    
    UITableView            *_tableView;
    AMapLocationManager    *_locationManager;
    CLLocationCoordinate2D _coordinate;//用于记录用户当前位置
    
}

@end

@implementation ViewController
-(void)viewWillDisappear:(BOOL)animated{
    [ super viewWillDisappear: animated];
    _locationManager.delegate=nil;
    _locationManager=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self   makeTableView];
    [self initWithLocationManager];//初始化定位
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)makeTableView{
    
    _tableView=[[ UITableView alloc] initWithFrame:self.view.frame style: UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[ UIView alloc] init];
    [self.view addSubview:_tableView];
    
}
-(void)initWithLocationManager
{
    
    _locationManager=[[ AMapLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=10000.0f;
    _locationManager.locationTimeout=10.f;
    
    [_locationManager startUpdatingLocation];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==1||section==2)return 1;
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[ tableView  dequeueReusableCellWithIdentifier:@"string12"];
    if (cell==nil)
    {
        
        cell=[[ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"string12"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0)//高德
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"驾车导航";
        }else{
         cell.textLabel.text=@"步行导航";
        }
    }else//百度导航
    {
        
     cell.textLabel.text=@"导航";
      
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view setBackgroundColor:[ UIColor darkGrayColor]];
    UILabel *lable=[[ UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width-30, 21)];
    lable.textAlignment=NSTextAlignmentCenter;
    [lable setTextColor:[ UIColor blackColor]];
    [view addSubview:lable];
    if (section==0)
    {
       lable.text=@"高德地图";
    } else if(section==1)
    {
        lable.text=@"百度地图";
    }else{
        
       lable.text=@"本地系统导航";
        
    }

    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((int)_coordinate.latitude==0 )return;
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            DriveAMPcontroller *drive=[[ DriveAMPcontroller alloc] init];
            drive.coordinate=_coordinate;
            [self.navigationController pushViewController:drive animated:YES];
        }else if (indexPath.row==1)
        {
            WalkAMPController *walk=[[ WalkAMPController alloc] init];
            walk.coordinate=_coordinate;
            [self.navigationController pushViewController:walk animated:YES];
        }
    }else if (indexPath.section==1)
    {
          BMKDriveController *drive=[[ BMKDriveController alloc] init];
          drive.coordinate=_coordinate;
         [self.navigationController pushViewController:drive animated:YES];
        
    }else //本地导航
    {
        
        // 直接调用ios自己带的apple map
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_coordinate addressDictionary:nil]];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:
                                                                      CLLocationCoordinate2DMake(39.915168,116.403875) addressDictionary:nil]];//目的地的位置
        toLocation.name = @"目的地";
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        [MKMapItem openMapsWithItems:items launchOptions:options]; //打开苹果自身地图应用，并呈现特定的item
        
        
        
    }
}
#pragma mark --private Method--定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
    [[[UIAlertView  alloc] initWithTitle:@"温馨提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    
}
#pragma mark --private Method--定位成功
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    _coordinate=location.coordinate;
    [_locationManager stopUpdatingLocation];//停止定位
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
