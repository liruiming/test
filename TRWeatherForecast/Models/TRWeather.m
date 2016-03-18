

//
//  TRWeather.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRWeather.h"

@implementation TRWeather
+ (id)weatherFromHourlyDic:(NSDictionary *)hourlyDic
{
    
    return [[self alloc]initWithHourlyDic:(NSDictionary *)hourlyDic];


}
- (instancetype)initWithHourlyDic:(NSDictionary *)hourlyDic
{
    if (self = [super init])
    {
        self.iconUrlStr = hourlyDic[@"weatherIconUrl"][0][@"value"];
        int time = [hourlyDic[@"time"] intValue]/100;
        self.time = [NSString stringWithFormat:@"%d:00",time];
        self.weatherTemp = [NSString stringWithFormat:@"%@℃",hourlyDic[@"tempC"]];
        self.weatherDesc = hourlyDic[@"weatherDesc"][0][@"value"];
   
        
    }
    return self;
}

+ (id)weatherFromDailyDic:(NSDictionary *)dailyDic
{
    return [[self alloc]initWithDailyDic:(NSDictionary *)dailyDic];

}

- (instancetype)initWithDailyDic:(NSDictionary *)dailyDic
{
    if (self = [super init])
    {
        self.iconUrlStr = dailyDic[@"hourly"][0][@"weatherIconUrl"][0][@"value"];
        self.date = dailyDic[@"date"];
        self.tempMaxC = [NSString stringWithFormat:@"%@℃",dailyDic[@"maxtempC"]];
        self.tempMinC = [NSString stringWithFormat:@"%@℃",dailyDic[@"mintempC"]] ;
    
        
    }
    return self;
}
@end
