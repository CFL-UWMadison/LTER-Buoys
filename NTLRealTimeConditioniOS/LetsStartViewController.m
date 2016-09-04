//
//  LetsStartViewController.m
//  UpdatedViewController
//
//  Created by Junjie on 6/12/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "LetsStartViewController.h"

@interface LetsStartViewController ()

@end

@implementation LetsStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startButton.layer.cornerRadius = 10;
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;
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

- (IBAction)exitGuide:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
