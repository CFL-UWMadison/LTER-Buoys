//
//  RootViewController.h
//  app for limnology Version 0
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

-(void)displayFavouriteAsFirstPage;
@end

