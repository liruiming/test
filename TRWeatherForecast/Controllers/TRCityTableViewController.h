//
//  TRCityTableViewController.h
//  TRWeatherForecast
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface TRCityTableViewController : UITableViewController
//声明block
//@property (nonatomic, copy) void (^ChangeCityBlock)(NSString *cityName);
@property (nonatomic, copy) void (^ChangeCityLocationBlock)(CLLocation *cityLocation);
@end
