//
//  ViewController.h
//  MenuViewTest
//
//  Created by Junjie on 6/3/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJWeatherViewController.h"
#import "UserSetting.h"
#import "DisclaimerViewController.h"


@class JJWeatherViewController;

@interface MenuViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (nonatomic) BOOL isBritish;
@property (nonatomic, strong) JJWeatherViewController* currentController;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
- (IBAction)returnButtonClicked:(id)sender;




@end

