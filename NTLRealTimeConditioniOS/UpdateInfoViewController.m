//
//  UpdateInfoViewController.m
//  UpdatedViewController
//
//  Created by Junjie on 6/12/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "UpdateInfoViewController.h"
#import "UpdateModel.h"

@interface UpdateInfoViewController ()

@end

@implementation UpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* updateImage = [UIImage imageNamed:self.updatedImage];
    if(updateImage){
      [self.updateImageView setImage:updateImage];
    }
    self.updateInfoText.text = self.updatedInfo;
    self.pageControl.currentPage = self.pageNum;
    [self.pageControl updateCurrentPageDisplay];
    self.pageControl.numberOfPages = [UpdateModel sharedUpdateModel].numOfPage;
    [self configureFontSize];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitUpdate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpUpdatedText:(NSString *)updatedInfo WithImageName:(NSString *)updatedImage{
    self.updatedInfo = updatedInfo;
    self.updatedImage = updatedImage;
}

-(NSString*) identifyModal{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return @"iPhone 5";
    } else if([[UIScreen mainScreen] bounds].size.height == 480) {
        return @"iPhone 4";
    } else if([[UIScreen mainScreen] bounds].size.height == 736) {
        return @"iPhone 6Plus";
    }
    return @"iPhone 6";
}

-(void) configureFontSize{
    if([[self identifyModal] isEqualToString: @"iPhone 4"]){
        self.updateInfoText.font = [UIFont systemFontOfSize:16];
    } else if ( [[self identifyModal] isEqualToString:@"iPhone 5"]){
        self.updateInfoText.font = [UIFont systemFontOfSize:17];
    } else if ( [[self identifyModal] isEqualToString:@"iPhone 6"]){
        self.updateInfoText.font = [UIFont systemFontOfSize:20];
    } else {
        self.updateInfoText.font = [UIFont systemFontOfSize:22];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
