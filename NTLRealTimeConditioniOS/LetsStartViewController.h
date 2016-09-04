//
//  LetsStartViewController.h
//  UpdatedViewController
//
//  Created by Junjie on 6/12/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetsStartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic) NSUInteger pageNum;
- (IBAction)exitGuide:(id)sender;

@end
