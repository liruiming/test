//
//  TRDataManager.h
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDataManager : NSObject
/** 读取CityGroup.plist数据,返回一个解析好的数组 (Dictionary -> TRCityGroup)*/
+ (NSArray*)getCityGroup;

//返回数组(TRWeather),给定服务器返回的responseObject
+ (NSArray*)weatherFromJSON:(id)responseObj isHourly:(BOOL)isHourly;

@end
