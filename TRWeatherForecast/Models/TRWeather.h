//
//  TRWeather.h
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRWeather : NSObject
/** 城市名字*/
@property (nonatomic, strong) NSString *cityName;
/** 天气图标url对应的str*/
@property (nonatomic, strong) NSString *iconUrlStr;
/** 天气描述*/
@property (nonatomic, strong) NSString *weatherDesc;
/** 当前天气温度*/
@property (nonatomic, strong) NSString *weatherTemp;
/** 最高温*/
@property (nonatomic, strong) NSString *tempMaxC;
/** 最低温*/
@property (nonatomic, strong) NSString *tempMinC;
/** 每小时的时间*/
@property (nonatomic, strong) NSString *time;
/** 每天的日期*/
@property (nonatomic, strong) NSString *date;

//给定字典,返回模型对象
+ (id)weatherFromHourlyDic:(NSDictionary *)hourlyDic;
//给定每天字典,返回模型对象
+ (id)weatherFromDailyDic:(NSDictionary *)dailyDic;
@end
