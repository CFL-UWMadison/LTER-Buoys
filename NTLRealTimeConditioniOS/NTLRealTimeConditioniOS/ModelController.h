//
//  ModelController.h
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 16/1/14.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

