//
//  DisclaimerViewController.h
//  AppForLakeWeather V0.5
//
//  Created by Junjie on 16/1/9.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DisclaimerViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property MFMailComposeViewController* mail;

- (IBAction)returnButton:(id)sender;
- (IBAction)feedback:(id)sender;



@end
