//
//  JJWeatherViewController.m
//  It controls the main view for displaying the data. It's xib is in the main.storyboard called
//  JJWeatherViewController
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "JJWeatherViewController.h"
#import "WeatherInfoDB.h"
#import "Weather.h"
#import "ModelController.h"
#import "DisclaimerViewController.h"
#import "RootViewController.h"

@interface JJWeatherViewController()
@property (atomic,strong) NSTimer* timer;
-(void)stopActivityView;
@end

@implementation JJWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.favouriteButton setTitle:@"Set as Homepage" forState:UIControlStateNormal];
    [self.favouriteButton setTitle:@"Unset this page" forState:UIControlStateSelected];
    [self.favouriteButton setTitleColor:[UIColor redColor]forState:UIControlStateSelected];
    self.activityView.hidesWhenStopped= YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeFontSizeByModal];
    [[WeatherInfoDB sharedDB] loadWeathers];
    [self displayData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(autoRefresh:) userInfo:nil repeats:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

//Action methods
- (IBAction)setHomePage:(id)sender{
    if([self.lake.favourite boolValue] == NO){
        self.lake.favourite = [NSNumber numberWithBool:YES];
        [[WeatherInfoDB sharedDB] checkForOtherHomepage:self.lake.lakeName];
        self.favouriteButton.selected = YES;
        
    }
    else{
        self.lake.favourite = [NSNumber numberWithBool:NO];
        self.favouriteButton.selected = NO;
        
    }
    [[WeatherInfoDB sharedDB] saveChanges];
    
}

-(IBAction)refresh:(id)sender{
    //activity view used to give user feedback on the action
    [self.activityView startAnimating];
    
    //refresh the data
    [[WeatherInfoDB sharedDB] loadWeathers];
    [self displayData];
    if([self checkOutdatedData:self.lake.sampleDate]){
        [self raiseTheAlert];
    }
    
    //stop the activity view after 1 second
    [self performSelector:@selector(stopActivityView) withObject:nil afterDelay:1.0];
 
}




//
-(void) autoRefresh: (NSTimer*) timer{
    [[WeatherInfoDB sharedDB] loadWeathers];
    [self displayData];
    NSLog(@"THIS WORKS!");
}


-(void)displayData{
    self.lakeName.text = self.lake.lakeName;
    
    //display air temperature
    double airTempC =[self.lake.airTempC doubleValue];
    if(airTempC>= -10 && airTempC <=50){
        self.airTempC.text = [NSString stringWithFormat:@"%.00f ºC / %.00f ºF", airTempC,[self.lake.airTempF doubleValue]];
    }else{
        self.airTempC.text =@"N/A";
    }
    
    //display water temperature
    double waterTempC = [self.lake.waterTempC doubleValue];
    if (waterTempC>= -5 && waterTempC <=50) {
        self.waterTempC.text = [NSString stringWithFormat:@"%.00f ºC / %.00f ºF",waterTempC,[self.lake. waterTempF doubleValue]];
    }else{
        self.waterTempC.text = @"N/A";
    }
    
    //display wind speed
    double windSpeed = [self.lake.windSpeed doubleValue];
    double windSpeedMph = windSpeed* 2.23694;
    if(windSpeed>=0 && windSpeed<= 30){
          self.windSpeed.text = [NSString stringWithFormat:@"%.01f m/s",windSpeed];
         self.windSpeedMph.text =[NSString stringWithFormat:@"%.01f mph",windSpeedMph];
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
        self.thermocline.text = [NSString stringWithFormat:@"%.00f ft",thermocline* 3.2808];
        
    }else{
        self.thermocline.text = @"N/A";
    }
    
    //display the sample date
    NSString* updateTime = [self dateString:self.lake.sampleDate];
    self.updateTime.text = [NSString stringWithFormat:@"Last updated: %@", updateTime];
    self.updateTime.font = [UIFont systemFontOfSize:20];
           
    //display secchiEst
    if(![self.lake.lakeName containsString:@"Mendota"]){
        self.secchiEstPrompt.text = @"";
        self.secchiEst.text = @"";
    } else{
        double secchiEst = [self.lake.secchiEst doubleValue];
        //what's the safe threshold
        if (secchiEst>=-1) {
            self.secchiEst.text = [NSString stringWithFormat:@"%.00f ft", secchiEst * 3.2808];
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
    
    //check whether the data is outdated for 5 days.
    if(intervalForChecking> intervalFor5Days){
        return YES;
    }
    return NO;
}

-(void) raiseTheAlert {
    //present the view controller
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"Outdated information" message:@"Reminder: The information you are about to view is still outdated for 5 days." preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [ac addAction:defaultAction];
    [self.view.window.rootViewController presentViewController:ac animated:YES completion:nil];
}

//convert the date to the specific format, such 1:10 09/30
-(NSString*) dateString: (NSDate*) date{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"MM/dd HH:mm";
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

//present the disclaimer over the current page.
- (IBAction)showAbout:(id)sender {
    DisclaimerViewController* dvc = [[DisclaimerViewController alloc] init];
    dvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:dvc animated:YES completion:nil];
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


//differnet Modal will have different size font to fit the screen
-(void) changeFontSizeByModal{
    if([[self identifyModal] isEqualToString:@"iPhone 6Plus"]){
        self.airTempC.font = [UIFont systemFontOfSize:30];
        self.windSpeed.font = [UIFont systemFontOfSize:28];
        self.windSpeedMph.font = [UIFont systemFontOfSize:28];
        self.waterTempC.font = [UIFont systemFontOfSize:30];
        self.thermocline.font = [UIFont systemFontOfSize:28];
        self.windDir.font = [UIFont systemFontOfSize:28];
        self.secchiEst.font = [UIFont systemFontOfSize:28];
        self.lakeName.font = [UIFont systemFontOfSize:39];
        self.updateTime.font = [UIFont systemFontOfSize:33];
        self.airTempPrompt.font = [UIFont boldSystemFontOfSize:23];
        self.waterTempPrompt.font = [UIFont boldSystemFontOfSize:23];
        self.windDir.font = [ UIFont systemFontOfSize:28];
        self.WindDirPrompt.font = [UIFont boldSystemFontOfSize:23];
        self.windSpeedPrompt.font =[UIFont boldSystemFontOfSize:23];
        self.thermoclinePrompt.font = [UIFont boldSystemFontOfSize:23];
        self.updateTime.font = [UIFont systemFontOfSize:21];
        self.secchiEstPrompt.font = [UIFont boldSystemFontOfSize:23];
    }
    if ([[self identifyModal] isEqualToString:@"iPhone 5"]) {
        NSLog(@"This is a iphone 5");
        self.airTempC.font = [UIFont systemFontOfSize:25];
        self.windSpeed.font = [UIFont systemFontOfSize:23];
        self.windSpeedMph.font = [UIFont systemFontOfSize:23];
        self.waterTempC.font = [UIFont systemFontOfSize:25];
        self.thermocline.font = [UIFont systemFontOfSize:23];
        self.windDir.font = [UIFont systemFontOfSize:23];
        self.secchiEst.font = [UIFont systemFontOfSize:23];
        self.lakeName.font = [UIFont systemFontOfSize:34];
        self.updateTime.font = [UIFont systemFontOfSize:28];
        self.airTempPrompt.font = [UIFont boldSystemFontOfSize:18];
        self.waterTempPrompt.font = [UIFont boldSystemFontOfSize:18];
        self.windDir.font = [ UIFont systemFontOfSize:23];
        self.WindDirPrompt.font = [UIFont boldSystemFontOfSize:18];
        self.windSpeedPrompt.font =[UIFont boldSystemFontOfSize:18];
        self.thermoclinePrompt.font = [UIFont boldSystemFontOfSize:18];
        self.updateTime.font = [UIFont systemFontOfSize:16];
        self.secchiEstPrompt.font = [UIFont boldSystemFontOfSize:18];
        
        
    } else if ([[self identifyModal] isEqualToString:@"iPhone 4"]){
        self.airTempC.font = [UIFont systemFontOfSize:23];
        self.windSpeed.font = [UIFont systemFontOfSize:20];
        self.windSpeedMph.font = [UIFont systemFontOfSize:20];
        self.waterTempC.font = [UIFont systemFontOfSize:23];
        self.thermocline.font = [UIFont systemFontOfSize:20];
        self.windDir.font = [UIFont systemFontOfSize:20];
        self.secchiEst.font = [UIFont systemFontOfSize:20];
        self.lakeName.font = [UIFont systemFontOfSize:32];
        self.updateTime.font = [UIFont systemFontOfSize:28];
        self.airTempPrompt.font = [UIFont boldSystemFontOfSize:16];
        self.waterTempPrompt.font = [UIFont boldSystemFontOfSize:16];
        self.windDir.font = [ UIFont systemFontOfSize:20];
        self.WindDirPrompt.font = [UIFont boldSystemFontOfSize:16];
        self.windSpeedPrompt.font =[UIFont boldSystemFontOfSize:16];
        self.thermoclinePrompt.font = [UIFont boldSystemFontOfSize:16];
        self.updateTime.font = [UIFont systemFontOfSize:14];
        self.secchiEstPrompt.font = [UIFont boldSystemFontOfSize:16];
    }
    
}

-(void)stopActivityView{
    [self.activityView stopAnimating];
}

@end
