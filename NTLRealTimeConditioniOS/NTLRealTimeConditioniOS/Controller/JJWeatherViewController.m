//
//  JJWeatherViewController.m
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "JJWeatherViewController.h"
#import "WeatherInfoDB.h"
#import "Weather.h"
#import "ModelController.h"
#import "DisclaimerViewController.h"
@interface JJWeatherViewController()

@end

@implementation JJWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.favouriteButton setTitle:@"Set to favourite" forState:UIControlStateNormal];
    [self.favouriteButton setTitle:@"Unlike this lake" forState:UIControlStateSelected];
    [self.favouriteButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayData];
    //[self checkOutdatedData:self.lake.sampleDate];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //check whether the data is outdated
    [self checkOutdatedData:self.lake.sampleDate];
}

- (IBAction)setFavourite:(id)sender {
    if([self.lake.favourite boolValue] == NO){
        self.lake.favourite = [NSNumber numberWithBool:YES];
        [[WeatherInfoDB sharedDB] checkForOtherFavourite:self.lake.lakeName];
        self.favouriteButton.selected = YES;
    }
    else{
        self.lake.favourite = [NSNumber numberWithBool:NO];
        self.favouriteButton.selected = NO;
    }
    [[WeatherInfoDB sharedDB] saveChanges];
}

-(IBAction)refresh:(id)sender{
    [[WeatherInfoDB sharedDB] loadWeathers];
    [self displayData];
    if([self checkOutdatedData:self.lake.sampleDate]){
        [self raiseTheAlert];
    }
}

-(void)displayData{
    self.lakeName.text = self.lake.lakeName;
    
    //display air temperature
    double airTempC =[self.lake.airTempC doubleValue];
    if(airTempC>= -10 && airTempC <=50){
        self.airTempC.text = [NSString stringWithFormat:@"%.02f ºC / %.02f ºF", airTempC,[self.lake.airTempF doubleValue]];
        //self.airTempF.text = [NSString stringWithFormat:@"%.02f ºF",[self.lake.airTempF doubleValue]];
    }else{
        self.airTempC.text =@"N/A";
    }
    
    //display water temperature
    double waterTempC = [self.lake.waterTempC doubleValue];
    if (waterTempC>= -5 && waterTempC <=50) {
        self.waterTempC.text = [NSString stringWithFormat:@"%.02f ºC / %.02f ºF",waterTempC,[self.lake.waterTempF doubleValue]];
        //self.waterTempF.text = [NSString stringWithFormat:@"%.02f ºF",[self.lake.waterTempF doubleValue]];
    }else{
        self.waterTempC.text = @"N/A";
    }
    
    //display wind speed
    double windSpeed = [self.lake.windSpeed doubleValue];
    double windSpeedMph = windSpeed* 2.23694;
    if(windSpeed>=0 && windSpeed<= 30){
          self.windSpeed.text = [NSString stringWithFormat:@"%.02f m/s",windSpeed];
         self.windSpeedMph.text =[NSString stringWithFormat:@"%.02f miles/h",windSpeedMph];
    }
    else{
        self.windSpeed.text = @"";
        self.windSpeedMph.text = @"N/A";
        
    }
   
    //Display Wind direction.
    self.windDir.text = [self directionForWind:[self.lake.windDir doubleValue]];
    if(self.lake.windDirImage){
        self.windDirImage.image = self.lake.windDirImage;
    }
    
    
    //display thermocline
    double thermocline = [self.lake.thermocline doubleValue];
    if(thermocline>= 0 && thermocline <=100){
        self.thermocline.text = [NSString stringWithFormat:@"%.02f m",thermocline];
    }else{
        self.thermocline.text = @"N/A";
    }
    
    //display the sample date
    if([self checkOutdatedData:self.lake.sampleDate]){
        self.updateTime.text = @"Data outdated";
        self.updateTime.font = [UIFont systemFontOfSize:31];
        self.updateTime.textColor = [UIColor redColor];
    }else{
        NSString* updateTime = [self dateString:self.lake.sampleDate];
        self.updateTime.text = [NSString stringWithFormat:@"Last updated: %@", updateTime];
        self.updateTime.font = [UIFont systemFontOfSize:15];
        self.updateTime.textColor = [UIColor blackColor];
    }
    
    //display secchiEst
    if(![self.lake.lakeName containsString:@"Mendota"]){
        self.secchiEstPrompt.text = @"";
        self.secchiEst.text = @"";
    } else{
        double secchiEst = [self.lake.secchiEst doubleValue];
        //what's the safe threshold
        if (secchiEst>=-1) {
            self.secchiEst.text = [NSString stringWithFormat:@"%.02f m", secchiEst];
        } else {
            self.secchiEst.text = @"N/A";
        }
    }
    self.pageControl.currentPage = self.pageIndex;
    [self.pageControl updateCurrentPageDisplay];
    
    //display whether favourite or not
    if([self.lake.favourite boolValue]){
        self.favouriteButton.selected = YES;
    }else{
        self.favouriteButton.selected = NO;
    }
    
   }

//This method check whether the data is outdated for 5 days. If yes, an alert will show up.
-(BOOL) checkOutdatedData: (NSDate*) anotherDate{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm:ss MM/dd/yyyy";
    
    //Get the interval of 5 days
    NSDate* date1 = [format dateFromString:@"00:00:00 09/30/1995"];
    NSDate* date2 = [format dateFromString:@"00:00:00 09/25/1995"];
    NSTimeInterval intervalFor5Days = [date1 timeIntervalSinceDate:date2];
    NSDate* current = [[NSDate alloc] init];
    NSTimeInterval intervalForChecking = [current timeIntervalSinceDate:anotherDate];
    NSLog(@"%@", anotherDate.description);
    
    if(intervalForChecking> intervalFor5Days){
        return YES;
    }
    return NO;
}

-(void) raiseTheAlert {
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"Outdated information" message:@"Reminder: The information you are about to view is still outdated for 5 days." preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [ac addAction:defaultAction];
        [self.view.window.rootViewController presentViewController:ac animated:YES completion:nil];
}

-(NSString*) dateString: (NSDate*) date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"HH:mm MM/dd/yyyy"; 
    return [format stringFromDate:date];
}

-(NSString*) directionForWind: (double) windDir{
    if(windDir> 348.75 && windDir<=11.25){
        return @"N";
    }else if(windDir> 11.25 && windDir<= 33.75){
        return @"NNE";
    } else if(windDir> 33.75 && windDir <= 56.25){
        return @"NE";
    } else if(windDir> 56.25 && windDir <= 78.75){
        return @"ENE";
    } else if(windDir> 78.75 && windDir <= 101.25){
        return @"E";
    } else if (windDir> 101.25 && windDir <= 123.75){
        return @"ESE";
    } else if (windDir> 123.75 && windDir <= 146.25){
        return @"SE";
    } else if (windDir> 146.25 && windDir <= 168.75){
        return @"SSE";
    } else if (windDir > 168.75 && windDir <= 191.25){
        return @"S";
    } else if (windDir > 191.25 && windDir <= 213.75){
        return @"SSW";
    } else if (windDir > 213.75 && windDir <= 236.25){
        return @"SW";
    } else if (windDir > 236.25 && windDir <= 258.75){
        return @"WSW";
    } else if (windDir > 258.75 && windDir <= 281.25){
        return @"W";
    } else if (windDir> 281.25 && windDir <= 303.75){
        return @"WNW";
    } else if (windDir> 303.75 && windDir <= 326.25){
        return @"NW";
    } else if (windDir> 326.25 && windDir < 348.75){
        return @"NNW";
    }
    
    return @"N/A";
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showAbout:(id)sender {
    DisclaimerViewController* dvc = [[DisclaimerViewController alloc] init];
    dvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:dvc animated:YES completion:nil];
}
@end
