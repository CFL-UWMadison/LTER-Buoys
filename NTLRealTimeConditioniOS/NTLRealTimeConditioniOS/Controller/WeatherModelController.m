//
//  ModelController.m
//
//
//  app for limnology Version 0
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "WeatherModelController.h"
#import "JJWeatherViewController.h"
#import "Weather.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface WeatherModelController ()

@property (readonly, strong, nonatomic) NSArray *lakesWeatherData; // the array for data.

@end

@implementation WeatherModelController

- (instancetype)init {
    return [self initWithDatabase:nil];
}

-(instancetype) initWithDatabase:(WeatherInfoDB*) db {
    self = [super init];
    if (self) {
        self.db = db;
    }
    return self;
}


- (JJWeatherViewController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    
    //update the database
    _lakesWeatherData = [self.db allLakes];
    
    // Return the data view controller for the given index.
    if (([self.lakesWeatherData count] == 0) || (index >= [self.lakesWeatherData count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    JJWeatherViewController *wvc = [storyboard instantiateViewControllerWithIdentifier:@"JJWeatherViewController"];
    
    //set the data
    wvc.lake = [self.lakesWeatherData objectAtIndex:index];
    NSLog(@"the index is %lu, the lake name is %@",(unsigned long)index, wvc.lake.lakeName);
    wvc.pageIndex = index;
    return wvc;
}

- (NSUInteger)indexOfViewController:(JJWeatherViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    for(int i=0; i< 3;i++){
        Weather* weatherInArray = [self.lakesWeatherData objectAtIndex:i];
        if([viewController.lake.lakeName isEqualToString:weatherInArray.lakeName]){
            return i;
        }
    }
    return -1;
}

#pragma mark - Page View Controller Data Source

// This is necessary to notice that the view controller will only be recreated through this method 
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{       
    
    NSUInteger index = [self indexOfViewController:(JJWeatherViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(JJWeatherViewController *)viewController];
    if (index == self.lakesWeatherData.count -1 ||   index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
