//
//  TRHeaderView.h
//  TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRHeaderView : UIView
//选择城市button
@property (nonatomic, strong)UIButton *selectedCityButton;
//城市label
@property (nonatomic, strong)UILabel *cityLabel;
//iconView
@property (nonatomic, strong)UIImageView *iconView;
//conditionsLabel
@property (nonatomic, strong)UILabel *conditionsLabel;
//temperatureLabel
@property (nonatomic, strong)UILabel *temperatureLabel;
//hiloLabel
@property (nonatomic, strong)UILabel *hiloLabel;
@end
