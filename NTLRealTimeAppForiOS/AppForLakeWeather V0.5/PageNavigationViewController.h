//
//  PageNavigationViewController.h
//  AppForLakeWeather V0.5
//
//  Created by Junjie on 16/1/9.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJWeatherViewController;
@interface PageNavigationViewController : UINavigationController <UIPageViewControllerDelegate>

@property (strong,nonatomic) UIPageViewController* pageViewController;

-(instancetype) initByPageViewController;

@end
