//
//  TRCityGroup.h
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCityGroup : NSObject
/** 城市数组*/
@property (nonatomic, strong) NSArray *cities;
/** 城市的标题*/
@property (nonatomic, strong) NSString *title;


@end
