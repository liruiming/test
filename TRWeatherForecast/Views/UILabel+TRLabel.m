//
//  UILabel+TRLabel.m
//  TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UILabel+TRLabel.h"

@implementation UILabel (TRLabel)
+ (UILabel *)labelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:28];
    label.textAlignment = NSTextAlignmentLeft;
    
    
    
    
    
    return label;
}
@end
