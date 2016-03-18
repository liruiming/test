//
//  TRDataManager.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRDataManager.h"
#import "TRCityGroup.h"
#import "TRWeather.h"
@implementation TRDataManager

static NSArray *cityGroup = nil;
+ (NSArray *)getCityGroup
{
    //只需读取一次文件,用单例
    if (cityGroup == nil)
    {
        cityGroup = [[self alloc] parseAndGetGroup];
    }
    
    return cityGroup;
    
}
- (NSArray*)parseAndGetGroup
{
    //获取plist数据(NSArray)
    //plist路径
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"cityGroups" ofType:@"plist"];
    
    NSArray *cityGroupArr = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *marray = [NSMutableArray array];
    //循环将字典转成模型(!!!)
    for (NSDictionary *cityGroupDic in cityGroupArr)
    {
        //dic -> TRCityGroup
        TRCityGroup *cityGroup = [TRCityGroup new];
        //模型类的属性名与字典中的key值一模一样,下面方法就能直接转换
        [cityGroup setValuesForKeysWithDictionary:cityGroupDic];
        [marray addObject:cityGroup];
        
    }
    return marray;
}

+ (NSArray *)weatherFromJSON:(id)responseObj isHourly:(BOOL)isHourly
{
   NSArray *dailyArr = responseObj[@"data"][@"weather"];
   NSArray *hourlyArr = dailyArr[0][@"hourly"];
    /*需求1:dailyArr[Dictionary] -> dailyArr[TRWeather]
      需求2:hourlyArr[Dictionary] -> hourlyArr[TRWeather]
     */
    NSMutableArray *hmarr = [NSMutableArray array];
    
    NSMutableArray *dmarr = [NSMutableArray array];
    if (isHourly)
    {
        //返回每小时的数据(数组)
        for (NSDictionary *hourlyDic in hourlyArr) {
            //hourlyDic -> TRWeather
            TRWeather *hourly = [TRWeather weatherFromHourlyDic:hourlyDic];
            [hmarr addObject:hourly];
            
        }
        return [hmarr copy];
    }
    else
    {
    //返回每天的数据(数组)
        for (NSDictionary *dailyDic in dailyArr)
        {
            //dailyDic -> TRWeather
            TRWeather *daily = [TRWeather weatherFromDailyDic:dailyDic];
            [dmarr addObject:daily];
            
        }
        
        return [dmarr copy];
    
    }
    

}
@end
