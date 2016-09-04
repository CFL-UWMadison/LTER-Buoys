//
//  UpdateModel.h
//  UpdatedViewController
//
//  Created by Junjie on 6/11/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UpdateInfoViewController.h"
#import "LetsStartViewController.h"

@interface UpdateModel : NSObject <UIPageViewControllerDataSource>
@property (nonatomic) NSUInteger numOfPage;
+(UpdateModel*) sharedUpdateModel;


-(UpdateInfoViewController*) viewControllerAtIndex : (int) index;
//- (NSUInteger)indexOfViewController:(UpdateInfoViewController *)viewController;


@end
