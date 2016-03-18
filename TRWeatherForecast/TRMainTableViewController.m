

//
//  TRMainTableViewController.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMainTableViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "TRHeaderView.h"
#import "TRDataManager.h"
#import "TRCityTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "TRWeather.h"
#import "UIImageView+WebCache.h"
@interface TRMainTableViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
/** 界面:UIImageView(背景图片)+UIImageView(模糊view)+tableView*/
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *mgr;
/** 存储用户的位置*/
@property (nonatomic, strong) CLLocation *userLocation;
/** 两个数组存储每小时和每天的数据*/
@property (nonatomic, strong) NSArray *hourlyArr;
@property (nonatomic, strong) NSArray *dailyArr;
@property (nonatomic, strong) TRHeaderView *headView;
@property (nonatomic, assign) int hour;
@end

@implementation TRMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建界面
    [self setupTableView];
    //创建自定义头部视图
    [self setupHeaderView];
    //开始定位
    [self getUserLocation];
    self.hour = [self getHourTime];
    
    }

//获取当前的时间(hour)
- (int)getHourTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"HH";
    return [[df stringFromDate:date] intValue];

}


- (void)setupHeaderView
{
    self.headView = [[TRHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //添加头部视图button的selector
    [self.headView.selectedCityButton addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    //设置tableView的headerView
    self.tableView.tableHeaderView = self.headView;
}
- (void)changeCity
{
//创建一个城市视图控制器
  TRCityTableViewController *cityTableViewController =  [TRCityTableViewController new];
//创建nav Controller
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cityTableViewController];
    
//    //使用block方式获取选择的城市的名字
//    cityTableViewController.ChangeCityBlock = ^(NSString *cityName)
//    {
//        NSLog(@"城市名字:%@",cityName);
//        NSString *s =[self transformToPinYin:cityName];
//       // self.headView.cityLabel.text = cityName;
//        NSLog(@"%@",s);
//    };
    
    //选择城市之后刷新选择城市的天气数据
    cityTableViewController.ChangeCityLocationBlock = ^(CLLocation *cityLocation)
    {
        //更新所选城市的定位
        self.userLocation = cityLocation;
        //更新所选城市的天气数据
        [self sendRequestToServer];

    };
    
//显示
    [self presentViewController:navi animated:YES completion:nil];

}
//将汉字转为没有声调和空格的拼音
//- (NSString *)transformToPinYin:(NSString *)wordStr
//{
//    NSMutableString *mutableStr = [NSMutableString stringWithString:wordStr];
//    //带声调
//    CFStringTransform((CFMutableStringRef)mutableStr, NULL, kCFStringTransformToLatin, false);
//    //不带声调
//    CFStringTransform((CFMutableStringRef)mutableStr, NULL, kCFStringTransformStripDiacritics, false);
//    //去掉空格
//    return [mutableStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    
//}
- (void)setupTableView
{
    CGRect bounds = [[UIScreen mainScreen]bounds];
    //背景视图
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"www.jpg"]];
    backgroundView.frame = bounds;
    [self.view addSubview:backgroundView];
    
    //模糊视图
    UIImageView *blurredView = [UIImageView new];
    blurredView.frame = bounds;
    [blurredView setImageToBlur:[UIImage imageNamed:@"www.jpg"] blurRadius:24 completionBlock:nil];
    blurredView.alpha = 0.5;
    [self.view addSubview:blurredView];
    
    //tableView
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = bounds;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    //设置paging属性(每页显示section对应的那些内容)
    self.tableView.pagingEnabled = YES;
   [self.view addSubview:self.tableView];
    
    
    
}
//修改status bar的颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{//lightWhite返回白色
    return   UIStatusBarStyleLightContent;
}
#pragma mark - 定位相关的方法
- (void) getUserLocation
{
    self.mgr = [CLLocationManager new];
    self.mgr.delegate = self;
    //默认iOS8.0以上版本
    [self.mgr requestWhenInUseAuthorization];

}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{ 
    switch (status)
    {
        case kCLAuthorizationStatusDenied:
            self.userLocation = nil;
            NSLog(@"用户不允许定位");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
            self.mgr.distanceFilter = 100;
           [self.mgr startUpdatingLocation];
            break;
    }
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
      self.userLocation = [locations lastObject];
    NSLog(@"%f, %f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude);
    
    self.mgr = nil;
    //发送请求(NSURLSession/AFNetworking)
    [self sendRequestToServer];
   // [self.mgr stopUpdatingLocation];

}


//更新headView
- (void)updateHeadView
{
    
    
    TRWeather *hw = self.hourlyArr[self.hour/3];
    [self.headView.iconView sd_setImageWithURL:[NSURL URLWithString:hw.iconUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.headView.conditionsLabel.text = hw.weatherDesc;
    self.headView.temperatureLabel.text = hw.weatherTemp;
    TRWeather *dw = self.dailyArr[0];
    self.headView.hiloLabel.text = [NSString stringWithFormat:@"%@/%@",dw.tempMaxC,dw.tempMinC];
    
    //反地理编码更新表头城市名cityLabel
    CLGeocoder *coder = [CLGeocoder new];
    [coder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks)
        {
            self.headView.cityLabel.text = placemark.addressDictionary[@"City"];
            
        }
        
    }];

}


- (void)sendRequestToServer
{
     //设定TSMessage默认显示的视图控制器
    [TSMessage setDefaultViewController:self];
    
    
     //准备:urlStr
    NSString *urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=3&key=8efd8857c9571506378ac13fd0542",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude];
    //测试传回location
    NSLog(@"ssssss:%f,sssss:%f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude);
    
    // 创建manager对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //发送get请求
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //解析返回的数据
        self.hourlyArr = [TRDataManager weatherFromJSON:responseObject isHourly:YES];
        self.dailyArr = [TRDataManager weatherFromJSON:responseObject isHourly:NO];
        
        //解析头部视图的值
        [self updateHeadView];
        //重新加载tableView
        [self.tableView reloadData];
        
        //TSMessage成功提示
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"定位成功" type:TSMessageNotificationTypeSuccess];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //TSMessage来显示消息给用户(不需要用户交互)
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请查看网络状态" type:TSMessageNotificationTypeWarning];
        
    }];
   
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.hourlyArr.count + 1;
    }
    else
    {
    return self.dailyArr.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    //cell的透明度和背景颜色
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //设置cell不可选
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置cell的文本颜色
    cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    
    
#warning TODO:设置cell的内容
    if (indexPath.section == 0)
    {
        //显示每个小时的数据
        if (indexPath.row == 0)
        {
           cell.textLabel.text = @"Hourly Forecast Info";
            //防止cell重用
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
        }
        else
        {
            
                TRWeather *hw = self.hourlyArr[indexPath.row - 1];
//                cell.textLabel.text = hw.time;
//                cell.detailTextLabel.text = hw.weatherTemp;
            [self configCell:cell withWeather:hw isHourly:YES];

        }
    }
    else
    {
    //显示每天的数据
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Daily Forecast Info";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
        }
        else
        {
            
          TRWeather *dw = self.dailyArr[indexPath.row - 1];

//        cell.textLabel.text = dw.date;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@",dw.tempMaxC,dw.tempMinC];
            [self configCell:cell withWeather:dw isHourly:NO ];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        return self.view.bounds.size.height /(self.hourlyArr.count + 1);
    }
   else
    {
        return self.view.bounds.size.height /(self.dailyArr.count + 1);
    }
//    NSInteger rowCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//    return self.view.bounds.size.height/rowCount;
    
}

#pragma mark - cell设置
- (void)configCell:(UITableViewCell *)cell withWeather:(TRWeather *)weather isHourly:(BOOL)isHourly
{
    cell.textLabel.text = isHourly ? weather.time : weather.date;
    cell.detailTextLabel.text = isHourly ? weather.weatherTemp : [NSString stringWithFormat:@"%@ / %@",weather.tempMaxC,weather.tempMinC];
//imageView(阻塞主线程)
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weather.iconUrlStr]]];
    //方案1: GCD/NSOPeration+图片缓存(内存/磁盘)
    //方案2: 第三方库SDWebImage
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:weather.iconUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
