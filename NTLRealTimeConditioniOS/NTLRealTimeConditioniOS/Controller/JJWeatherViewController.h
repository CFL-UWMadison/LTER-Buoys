//
//  JJWeatherViewController.h
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Weather;
@interface JJWeatherViewController : UIViewController <UIPopoverPresentationControllerDelegate, UIScrollViewDelegate>

// All of the labels in the xib

@property (weak, nonatomic) IBOutlet UILabel *lakeName;
@property (weak, nonatomic) IBOutlet UILabel *airTempC;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDir;
@property (weak, nonatomic) IBOutlet UILabel *waterTempC;
@property (weak, nonatomic) IBOutlet UILabel *thermocline;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *secchiEst;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedMph;
@property (weak, nonatomic) IBOutlet UIImageView *windDirImage;


@property (weak, nonatomic) IBOutlet UILabel *airTempPrompt;
@property (weak, nonatomic) IBOutlet UILabel *waterTempPrompt;
@property (weak, nonatomic) IBOutlet UILabel *WindDirPrompt;
@property (weak, nonatomic) IBOutlet UILabel *thermoclinePrompt;
@property (weak, nonatomic) IBOutlet UILabel *secchiEstPrompt;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedPrompt;


@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
// data field for this view controller
@property (nonatomic) Weather* lake;
@property (nonatomic) int pageIndex;

//Action the view controller can do
- (IBAction)showAbout:(id)sender;
- (IBAction)setHomePage:(id)sender;
- (IBAction)refresh:(id)sender;


@end
