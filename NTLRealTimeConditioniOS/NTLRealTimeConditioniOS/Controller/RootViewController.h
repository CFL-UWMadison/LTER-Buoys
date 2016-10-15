//
//  RootViewController.h
//  app for limnology Version 0
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJWeatherViewController.h"
#import "UserSetting.h"
#import "WeatherInfoDB.h"

@interface RootViewController : UIViewController <UIPageViewControllerDelegate, WeatherInfoDBDelegate>

@property (strong, nonatomic) UIPageViewController *lakePageViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) JJWeatherViewController* currentViewController;
@property (strong, nonatomic) UIPageViewController *updatePageViewController;

@property (nonatomic,strong) NSTimer* currentDisplayTimer;
@property (nonatomic) BOOL unconnection;
@property (nonatomic,strong) UINavigationController* nvc;

-(void) alertForUnconnection;
-(void)displayFavouriteAsFirstPage;
-(void) startWeatherDBTimer;
-(void) endWeatherDBTimer;
@end

