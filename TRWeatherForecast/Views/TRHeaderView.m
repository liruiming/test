//
//  TRHeaderView.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRHeaderView.h"
#import "UILabel+TRLabel.h"
#import "TRMainTableViewController.h"
//设定高度/宽度的常量
static CGFloat statusBarHeight = 20;
static CGFloat labelHeight = 40;
static CGFloat tempHeight = 110;
static CGFloat margin = 20;
@implementation TRHeaderView

//重写父类方法
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        
        //提示:frame是整个屏幕的frame
        CGRect cityButtonFrame = CGRectMake(0, statusBarHeight, 2*labelHeight, labelHeight);
        
       self.selectedCityButton = [[UIButton alloc]init];
        //文本
        [self.selectedCityButton setTitle:@"City" forState:0];
        self.selectedCityButton.font =[UIFont fontWithName:@"ChalkboardSE-Bold" size:28];
        //frame
        self.selectedCityButton.frame = cityButtonFrame;
        //添加button
        [self addSubview:self.selectedCityButton];
        
        
        CGRect cityLabelFrame = CGRectMake(self.selectedCityButton.bounds.size.width, statusBarHeight, frame.size.width-2*labelHeight, labelHeight);
        self.cityLabel = [UILabel labelWithFrame:cityLabelFrame];
        self.cityLabel.text = @"loading...";
        self.cityLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.cityLabel];
        
        //hiloLabel
        CGRect hiloLabelFrame = CGRectMake(statusBarHeight, frame.size.height-labelHeight, frame.size.width - 2*margin, labelHeight);
        
        self.hiloLabel = [UILabel labelWithFrame:hiloLabelFrame];
        self.hiloLabel.text = @"0°/0°";
         self.temperatureLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:67];
        [self addSubview:self.hiloLabel];
       
        //temperatureLabel
        CGRect temperatureLabelFrame =  CGRectMake(margin, frame.size.height-labelHeight-tempHeight, frame.size.width - 2*margin, tempHeight);
        self.temperatureLabel = [UILabel labelWithFrame:temperatureLabelFrame];
        self.temperatureLabel.text = @"0℃";
        self.temperatureLabel.font = [UIFont fontWithName:@"Chalkduster" size:100];
        [self addSubview:self.temperatureLabel];
        
        //iconView
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, frame.size.height-labelHeight-self.temperatureLabel.bounds.size.height-labelHeight, labelHeight, labelHeight)];
        self.iconView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.iconView];
        
        //conditionsLabel
        CGRect conditionsLabelFrame = CGRectMake(margin+labelHeight,frame.size.height-labelHeight-self.temperatureLabel.bounds.size.height-labelHeight, frame.size.width-2*labelHeight, labelHeight);
        self.conditionsLabel = [UILabel labelWithFrame:conditionsLabelFrame];
        self.conditionsLabel.text = @"";
        [self addSubview:self.conditionsLabel];
        
    }
    return self;
}

@end
