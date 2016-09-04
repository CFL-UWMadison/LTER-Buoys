//
//  ViewController.m
//  MenuViewTest
//
//  Created by Junjie on 6/3/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "MenuViewController.h"



@interface MenuViewController ()

@property (nonatomic,strong) NSArray* settingArray;
@property (nonatomic,strong) NSArray* unitSetting;
@property (nonatomic,strong) NSArray* informationSetting;
@property (nonatomic,strong) UITapGestureRecognizer* singleFingerTap;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingArray = @[@"Information",@"Change File",@"Different Lake"];
    self.unitSetting = @[@"British", @"Metric"];
    self.informationSetting = @[@"About this app"];

    self.isBritish = ([UserSetting sharedSetting]).isBritish;
    self.singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleFingerTap.delegate = self;
    [self.backgroundView addGestureRecognizer:self.singleFingerTap];
    
    self.menuTable.dataSource = self;
    self.menuTable.delegate = self;
  
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self unitCellChange:self.menuTable];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isDescendantOfView:self.menuTable]){
        return NO;
    }
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer*) recoginzer{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.currentController displayData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Unit";
    }
    else if (section == 1){
        return @"Information";
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.unitSetting.count;
    }
    else if(section == 1){
        return self.informationSetting.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Unit Change
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text containsString:@"Bri"]){
        self.isBritish = YES;
        [self unitCellChange:tableView];
    }else if  ([cell.textLabel.text containsString:@"Met"]){
        self.isBritish = NO;
        [self unitCellChange:tableView];
    }
    
    [UserSetting sharedSetting].isBritish = self.isBritish;
    [[UserSetting sharedSetting] saveUserSetting];
    
    if([cell.textLabel.text containsString:@"About this"]){
        DisclaimerViewController* dvc = [[DisclaimerViewController alloc] init];
        dvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:dvc animated:YES completion:nil];
    }
}

-(void) unitCellChange :  (UITableView*) tableView{
    NSIndexPath *briPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *metPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell* briCell = [tableView cellForRowAtIndexPath:briPath];
    UITableViewCell* metCell = [tableView cellForRowAtIndexPath:metPath];
    if(_isBritish){
        briCell.accessoryType = UITableViewCellAccessoryCheckmark;
        metCell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        
        briCell.accessoryType = UITableViewCellAccessoryNone;
        metCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    
    if(section == 0){
         cell.textLabel.text = self.unitSetting[row];
        
        if([cell.textLabel.text containsString:@"Met"] && self.isBritish == NO ){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else if([cell.textLabel.text containsString:@"Bri"] && self.isBritish == YES ){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    else if (section == 1){
         cell.textLabel.text = self.informationSetting[row];
    }

    
    return cell;
}


@end
