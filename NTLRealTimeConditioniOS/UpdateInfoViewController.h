//
//  UpdateInfoViewController.h
//  UpdatedViewController
//
//  Created by Junjie on 6/12/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateInfoViewController : UIViewController
@property (strong,nonatomic) NSString* updatedInfo;
@property (strong,nonatomic) NSString* updatedImage;
@property (nonatomic) NSUInteger pageNum;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITextView *updateInfoText;
@property (weak, nonatomic) IBOutlet UIImageView *updateImageView;
- (IBAction)exitUpdate:(id)sender;
-(void) setUpUpdatedText: (NSString*) updatedInfo WithImageName: (NSString*) updatedImage;

@end
