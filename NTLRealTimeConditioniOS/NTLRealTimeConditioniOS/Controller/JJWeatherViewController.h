//
//  JJWeatherViewController.h
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Weather;
@interface JJWeatherViewController : UIViewController <UIPopoverPresentationControllerDelegate>
//@property (nonatomic)  UIAlertController* ac;
@property (weak, nonatomic) IBOutlet UILabel *lakeName;
@property (weak, nonatomic) IBOutlet UIImageView *questionMark;
@property (weak, nonatomic) IBOutlet UIImageView *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *airTempC;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDir;
@property (weak, nonatomic) IBOutlet UILabel *waterTempC;
@property (weak, nonatomic) IBOutlet UILabel *thermocline;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *airTempF;
@property (weak, nonatomic) IBOutlet UILabel *waterTempF;
@property (weak, nonatomic) IBOutlet UILabel *secchiEstPrompt;
@property (weak, nonatomic) IBOutlet UILabel *secchiEst;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedMph;
@property (weak, nonatomic) IBOutlet UIImageView *windDirImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) int pageIndex;
- (IBAction)showAbout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@property (nonatomic) Weather* lake; // it will be passed by the model controller
- (IBAction)setFavourite:(id)sender;

-(IBAction)refresh:(id)sender;
-(BOOL) checkOutdatedData: (NSDate*) anotherDate;

@end
