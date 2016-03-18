
//
//  TRCityTableViewController.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCityTableViewController.h"
#import "TRDataManager.h"
#import "TRCityGroup.h"
#import <CoreLocation/CoreLocation.h>
#import "TRMainTableViewController.h"
@interface TRCityTableViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *cityGroupArr;
@end
@implementation TRCityTableViewController
- (NSArray *)cityGroupArr
{
    if (!_cityGroupArr) {
        _cityGroupArr = [TRDataManager getCityGroup];
        
    }
    return _cityGroupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackItem)];
    //添加item
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

- (void)clickBackItem
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.cityGroupArr.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//section对应的模型对象
    TRCityGroup *cityGroup = self.cityGroupArr[section];
    return cityGroup.cities.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TRCityGroup *cityGroup = self.cityGroupArr[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];

    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TRCityGroup *cityGroup = self.cityGroupArr[section];
    return cityGroup.title;

}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//方案1:遍历cityGroupArr数组,取出所有的title
    
    //方案2:给key,返回所有的title组成的数组
    return [self.cityGroupArr valueForKeyPath:@"title"];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //数据来源
      TRCityGroup *cityGroup = self.cityGroupArr[indexPath.section];
      NSString *cityName = cityGroup.cities[indexPath.row];
    //地理编码
    CLGeocoder *coder = [CLGeocoder new];
    [coder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks)
        {
            NSLog(@"%@:%f, %f",cityName,placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            self.ChangeCityLocationBlock(placemark.location);
            
        }
        
    }];
    
    
    //传城市名字
   // self.ChangeCityBlock(cityName);
    //收回当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
