//
//  JJWeatherViewController.h
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJWeatherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *LakeName;
@property (weak, nonatomic) IBOutlet UIImageView *questionMark;
@property (weak, nonatomic) IBOutlet UIImageView *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *airTempC;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDir;

@property (weak, nonatomic) IBOutlet UILabel *waterTempC;
@property (weak, nonatomic) IBOutlet UILabel *Themocline;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *airTempF;
@property (weak, nonatomic) IBOutlet UILabel *waterTempF;

@end
