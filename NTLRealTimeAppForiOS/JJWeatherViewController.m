//
//  JJWeatherViewController.m
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "JJWeatherViewController.h"
#import "JJLakeWeather.h"
#import "WeatherInfoDB.h"
#import "Entity.h"

@interface JJWeatherViewController ()
@property WeatherInfoDB* db;
@end

@implementation JJWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [WeatherInfoDB sharedDB];
    [self.db loadWeathers];
   Entity* lake1 = [self.db.allLakes objectAtIndex:0];
    
    
    self.LakeName.text = lake1.lakeName;
    self.airTempC.text = [NSString stringWithFormat:@"%.02f C",[lake1.airTempC doubleValue]];
    self.waterTempC.text = [NSString stringWithFormat:@"%.02f C",[lake1.waterTempC doubleValue]];
    self.windDir.text = [NSString stringWithFormat:@"%.02f",[lake1.windDir doubleValue]];
    self.windSpeed.text = [NSString stringWithFormat:@"%.02f m/s",[lake1.windSpeed doubleValue]];
    self.airTempF.text = [NSString stringWithFormat:@"%.02f F",[lake1.airTempF doubleValue]];
    
    self.waterTempF.text = [NSString stringWithFormat:@"%.02f F",[lake1.waterTempF doubleValue]];
    
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

@end
