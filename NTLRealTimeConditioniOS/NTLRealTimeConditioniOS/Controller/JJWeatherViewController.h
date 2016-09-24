//
//  JJWeatherViewController.h
//  AppForLiminology View
// The view controller for the main information display view
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UserSetting.h"
#import "WeatherInfoDB.h"

@class Weather;
@class WeatherInfoDB;
typedef NS_ENUM(NSInteger,UnitType){
    metricUnit,
    britishUnit
    
} ;

@interface JJWeatherViewController : UIViewController <UIPopoverPresentationControllerDelegate, UIScrollViewDelegate>

// All of the labels in the xib
@property (weak, nonatomic) IBOutlet UILabel *lakeName;
@property (weak, nonatomic) IBOutlet UILabel *airTemp;
@property (weak, nonatomic) IBOutlet UILabel *windDir;
@property (weak, nonatomic) IBOutlet UILabel *waterTemp;
@property (weak, nonatomic) IBOutlet UILabel *thermocline;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *secchiEst;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UIImageView *windDirImage;


@property (weak, nonatomic) IBOutlet UILabel *airTempPrompt;
@property (weak, nonatomic) IBOutlet UILabel *waterTempPrompt;
@property (weak, nonatomic) IBOutlet UILabel *WindDirPrompt;
@property (weak, nonatomic) IBOutlet UILabel *thermoclinePrompt;
@property (weak, nonatomic) IBOutlet UILabel *secchiEstPrompt;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedPrompt;
@property (weak, nonatomic) IBOutlet UILabel *forMoreInformation;
@property (weak, nonatomic) IBOutlet UILabel *windGustPrompt;

@property (weak, nonatomic) IBOutlet UILabel *airTempUnit;
@property (weak, nonatomic) IBOutlet UILabel *waterTempUnit;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedUnit;
@property (weak, nonatomic) IBOutlet UILabel *thermoclineUnit;
@property (weak, nonatomic) IBOutlet UILabel *secchiEstUnit;
@property (weak, nonatomic) IBOutlet UILabel *windGust;


@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

+(JJWeatherViewController*) newWeatherVCWithDatabase:(WeatherInfoDB*) db
                                        inStoryBoard:(UIStoryboard*) storyboard;

// data field for this view controller
@property (nonatomic) Weather* lake;
@property (nonatomic) int pageIndex;
@property (nonatomic) BOOL unconnected;
@property (nonatomic) UnitType unitType;

//-(void) setWeatherDB:(WeatherInfoDB*) db;
-(void) endTimer;
-(void) displayData;
-(void) displayUnconnection;

//Action the view controller can do
- (IBAction)showAbout:(id)sender;
- (IBAction)setHomePage:(id)sender;
- (IBAction)refresh:(id)sender;

// This method will be used by the root view controller to start to
-(void)displayNetworkConnection: (BOOL) connected;

@end
