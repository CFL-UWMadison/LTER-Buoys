//
//  ModelController.h
//  This class is providing the datasource for the UI Page View Controller
//  
//  app for limnology Version 0
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfoDB.h"

@class JJWeatherViewController;
@class DataViewController;

@interface WeatherModelController : NSObject <UIPageViewControllerDataSource>

- (JJWeatherViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(JJWeatherViewController *)viewController;
@property (nonatomic, strong) WeatherInfoDB * db;// the database

@end

