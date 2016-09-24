//
//  DisclaimerViewController.m
//  It's the view controller controlling the "About" view. This module contains feedback button, disclamier
//
//  Created by Junjie on 16/1/9.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import "DisclaimerViewController.h"


@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)feedback:(id)sender {
    self.mail = [[MFMailComposeViewController alloc]init];
    self.mail.mailComposeDelegate = self;
    [self.mail setSubject:@"Feedback for the LTER App"];
    
    NSArray* recipents = @[@"jxu259@wisc.edu"];
    [self.mail setToRecipients:recipents];
    
    NSString* messageBody = @"Hello";
    [self.mail setMessageBody:messageBody isHTML:YES];
    
    [self presentViewController:self.mail animated:YES completion:^{NSLog(@"HELLO");}];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self.mail dismissViewControllerAnimated:YES completion:nil];
}
@end
