//
//  DataViewController.m
//  app for limnology Version 0
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        NSLog(@"The data has been loaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
    NSLog(@"The data has been updated");
}

@end
