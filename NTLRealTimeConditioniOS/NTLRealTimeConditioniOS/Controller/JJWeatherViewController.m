//
//  JJWeatherViewController.m
//  It controls the main view for displaying the data. It's xib is in the main.storyboard called
//  JJWeatherViewController
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "JJWeatherViewController.h"
#import "Weather.h"
#import "WeatherModelController.h"
#import "DisclaimerViewController.h"
#import "RootViewController.h"
#import <math.h>
#import "IphoneModelSizeIdentifier.h"

@class IphoneModalSizeIndentifier;

@interface JJWeatherViewController()
// For automatically updating the data
@property (nonatomic,weak) MenuViewController* mvc;

// I'm trying to get rid of this db dependency. My ideal is JJWeatherViewController only holds the Menu.
@property (nonatomic, weak) WeatherInfoDB* db;

@end

@implementation JJWeatherViewController

+(JJWeatherViewController*) newWeatherVCWithDatabase:(WeatherInfoDB*) weatherInfoDB
                                        InStoryBoard:(UIStoryboard*) storyboard{
    JJWeatherViewController* newinstance = [storyboard instantiateViewControllerWithIdentifier:@"JJWeatherViewController"];
    //[newinstance setWeatherDB:weatherInfoDB];
    //[newinstance addNetworkDidCheckNotification];
    
    return newinstance;
}

-(void) setWeatherDB:(WeatherInfoDB*) db{
    self.db = db;
}

-(void) addNetworkDidCheckNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:(@selector(receiveNetworkNotification:)) name:@"NetworkDidCheckNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NetworkDidCheckNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self receiveNetworkNotification:note];
    }];
}

-(void) receiveNetworkNotification:(NSNotification *) notification{
    NSDictionary* dict = [notification userInfo];
    BOOL isNetworkOn = [dict objectForKey:@"isNetworkOn"];
    
    //display the network connection based on the networkNotification
    [self displayNetworkConnection:isNetworkOn];
    
    // display unconnection
    self.unconnected = !isNetworkOn;
}

//This method will be used to display the information about the network connection
-(void)displayNetworkConnection: (BOOL) connected{
    if(!connected){
        self.forMoreInformation.text = @" Network Connection Failed! ";
        self.forMoreInformation.font = [UIFont boldSystemFontOfSize:17];
        self.forMoreInformation.textColor = [UIColor redColor];
    }else{
        self.forMoreInformation.font = [UIFont systemFontOfSize:10];
        self.forMoreInformation.textColor = [UIColor blackColor];
        self.forMoreInformation.text = @"For more information, https://lter.limnology.wisc.edu/about/lakes";
    }
}

//The inherited method from the view controller
- (void)viewDidLoad {
    [super viewDidLoad];

    //Home page button will be set to the
    [self.favouriteButton setTitle:@"Set as Homepage" forState:UIControlStateNormal];
    [self.favouriteButton setTitle:@"Unset this page" forState:UIControlStateSelected];
    [self.favouriteButton setTitleColor:[UIColor redColor]forState:UIControlStateSelected];
    
    // Set up the activity view
    self.activityView.hidesWhenStopped= YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self changeFontSizeByModal];
    [self sendUpdateDataNotification];
    [self displayData];
}

-(void)sendUpdateDataNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataNeedsUpdateNotification" object:self];
}

// The current controller will not be used in the future. Only the Root view controller will know it.
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

// Set or unset this lake view as homepage
- (IBAction)setHomePage:(id)sender{
    
    if ([self isHomepage]){
        [self setUserSettingHomePage: @"None"];
        self.favouriteButton.selected = NO;
    }else{
        [self setUserSettingHomePage: self.lake.lakeId];
        self.favouriteButton.selected = YES;
    }
}

-(BOOL) isHomepage{

    NSString* homepage = [self readInHomePage];
    NSLog(@"the homepage is %@", homepage);
    NSString* thisLakeID = self.lake.lakeId;
    
    if([homepage isEqualToString:thisLakeID]){
        return YES;
    } else{
        return NO;
    }
}

-(NSString*) readInHomePage{
    UserSetting* userSetting = [UserSetting sharedSetting];
    return userSetting.homepage;
}

-(void) setUserSettingHomePage:(NSString*) lakeID {
    UserSetting* userSetting = [UserSetting sharedSetting];
    userSetting.homepage = lakeID;
    [userSetting saveUserSetting];
}

//the refresh will be pressed to refresh the data
-(IBAction)refresh:(id)sender{
    //activity view used to give user feedback on the action
    [self.activityView startAnimating];
    
    //refresh the data
    [self sendUpdateDataNotification];
    //[self displayData];
    
    
    if([self checkOutdatedData:self.lake.sampleDate]){
        [self raiseTheAlert];
    }
    
    //stop the activity view after 1 second
    [self performSelector:@selector(stopActivityView) withObject:nil afterDelay:1.0];
}



/*
- (IBAction)configureUnit:(id)sender {
    NSString* type = [self.unitControl titleForSegmentAtIndex: [self.unitControl selectedSegmentIndex]];
    
    if([type isEqualToString:@"Bri"]){
        self.unitType = britishUnit;
    } else{
        self.unitType = metricUnit;
    }
    
    [self displayData];
}
*/


//the whole display data probably need to be rewritten. This time I need to create two pretty similar case. The first one is for metric and the second is for British. So here comes the question, how do I organize the control.
-(void)displayData{
    
    BOOL isBritish = [UserSetting sharedSetting].isBritish;
    if (isBritish) {
        self.unitType = britishUnit;
    } else {
        self.unitType = metricUnit;
    }
    
    switch (self.unitType) {
        case metricUnit:
            [self displayDataInMetric];
            
            break;
        
        case britishUnit:
            [self displayDataInBritish];
            
            break;
            
    }
    
    //display the sample date
    NSString* updateTime = [self dateString:self.lake.sampleDate];
    self.updateTime.text = [NSString stringWithFormat:@"Updated: %@", updateTime];
    
    self.pageControl.currentPage = self.pageIndex;
    [self.pageControl updateCurrentPageDisplay];
    
    //display whether this lake is homepage
    [self displayHomePage];
    
    //[self displayNetworkConnection:self.unconnected];
    
}

-(void) displayHomePage{
    if([self isHomepage]){
        self.favouriteButton.selected = YES;
    }else{
        self.favouriteButton.selected = NO;
    }
}

-(double) celeciusToF:(double) celcius{
    double f = celcius * 1.8 + 32;
    return f;
}

-(void) displayDataInBritish{
    NSLog(@"Displaying In British");
    
    self.lakeName.text = self.lake.lakeName;
    
    //display air temperature, the standard I set is arbitrary, but consistent with the metric Unit
    double airTempF = [self celeciusToF:[self.lake.airTemp doubleValue]];
    
    if(airTempF>= 14 && airTempF <= 122){
        self.airTemp.text = [NSString stringWithFormat:@"%.00f", airTempF];
        self.airTempUnit.text = @"°F";
    }else{
        self.airTemp.text = @"N/A";
        self.airTempUnit.text = @"";
    }
    
    //display water temperature
    double waterTempF = [self celeciusToF:[self.lake.waterTemp doubleValue]];
    if (waterTempF>= 23 && waterTempF <=122) {
        self.waterTemp.text = [NSString stringWithFormat:@"%.00f", waterTempF];
        self.waterTempUnit.text = @"°F";
    }else{
        self.waterTemp.text = @"N/A";
        self.waterTempUnit.text = @"";
    }
    
    //display wind speed
    double windSpeedMph = [self.lake.windSpeed doubleValue]* 2.23694;
    windSpeedMph = round(windSpeedMph);
    if(windSpeedMph>=0 && windSpeedMph<= 67){
        self.windSpeed.text =[NSString stringWithFormat:@"%.00f",windSpeedMph];
        self.windSpeedUnit.text = @"mph";
        
    }
    else{
        self.windSpeed.text = @"N/A";
        self.windSpeedUnit.text = @"";
    }
    
    double windGustMph = [self.lake.windGust doubleValue]* 2.23694;
    windGustMph = round(windGustMph);
    if(windGustMph >= 0 && windGustMph <= 67 && windGustMph > windSpeedMph ){
        self.windGust.text = [NSString stringWithFormat:@"%.00f", windGustMph];
        self.windGustPrompt.text = @"GUST";
        }else{
        self.windGust.text = @"";
        self.windGustPrompt.text = @"";
        
       // self.windGust.text = @"N/A";
       // self.windGustPrompt.text = @"GUST";
    }

    self.windDir.text = [NSString stringWithFormat:@"%.00f°", [self.lake.windDir doubleValue]];
    
    //Display Wind direction.
    /*self.windDir.text = [self directionForWind:[self.lake.windDir doubleValue]];
    if(self.lake.windDirImage){
        self.windDirImage.image = self.lake.windDirImage;
    }*/
    
    //display thermocline
    double thermoclineFeet = [self.lake.thermoclineDepth doubleValue] * 3.2808;
    if(thermoclineFeet >= 0 && thermoclineFeet <=164){
        self.thermocline.text = [NSString stringWithFormat:@"%.00f",thermoclineFeet];
        self.thermoclineUnit.text = @"ft";
    }else{
        self.thermocline.text = @"N/A";
        self.thermoclineUnit.text = @"";
        
    }
    
    //display secchiEst
    if(![self.lake.lakeName containsString:@"Mendota"]){
        self.secchiEstPrompt.text = @"";
        self.secchiEst.text = @"";
        self.secchiEstUnit.text = @"";
    } else{
        double secchiEstFeet = [self.lake.secchiEst doubleValue]*3.2808;
        if (secchiEstFeet>=-3.2) {
            self.secchiEst.text = [NSString stringWithFormat:@"%.00f", secchiEstFeet];
            self.secchiEstUnit.text = @"ft";
        } else {
            self.secchiEst.text = @"N/A";
        }
    }
}

-(void) displayDataInMetric{
    
    NSLog(@"Displaying In Metric");
    
    self.lakeName.text = self.lake.lakeName;
    
    //display air temperature, the standard I set is arbitrary, but consistent with the metric Unit
    double airTempC = [self.lake.airTemp doubleValue];
    if(airTempC>= -10 && airTempC <= 50){
        self.airTemp.text = [NSString stringWithFormat:@"%.00f", airTempC];
        self.airTempUnit.text = @"°C";
        
    }else{
        self.airTemp.text = @"N/A";
        self.airTempUnit.text = @"";
        
    }
        
    //display water temperature
    double waterTempC = [self.lake.waterTemp doubleValue];
    if (waterTempC>= -5 && waterTempC <= 50) {
        self.waterTemp.text = [NSString stringWithFormat:@"%.00f", waterTempC];
        self.waterTempUnit.text = @"°C";
        
    }else{
        self.waterTemp.text = @"N/A";
        self.waterTempUnit.text = @"";
    }
        
    //display wind speed
    double windSpeedMs = [self.lake.windSpeed doubleValue];
    windSpeedMs = round(windSpeedMs);
    if(windSpeedMs>=0 && windSpeedMs<= 30){
        self.windSpeed.text =[NSString stringWithFormat:@"%.00f",windSpeedMs];
        self.windSpeedUnit.text = @"m/s";
    }
    else{
        self.windSpeed.text = @"N/A";
        self.windSpeedUnit.text = @"";
    }
    
    self.windDir.text = [NSString stringWithFormat:@"%.00f°", [self.lake.windDir doubleValue]];
    /*
    //Display Wind direction.
    self.windDir.text = [self directionForWind:[self.lake.windDir doubleValue]];
    if(self.lake.windDirImage){
        self.windDirImage.image = self.lake.windDirImage;
    }*/
        
    
    //display windGust
    double windGustMs = [self.lake.windGust doubleValue];
    windGustMs = round(windGustMs);
    if(windGustMs >= 0 && windGustMs <= 30 && windGustMs > windSpeedMs){
        self.windGust.text = [NSString stringWithFormat:@"%.00f", windGustMs];
        self.windGustPrompt.text = @"GUST";
    }else{
        self.windGust.text = @"";
        self.windGustPrompt.text = @"";
    }
    
    
    
    //display thermocline
    double thermoclineM = [self.lake.thermoclineDepth doubleValue];
    if(thermoclineM >= 0 && thermoclineM <=50){
        self.thermocline.text = [NSString stringWithFormat:@"%.00f",thermoclineM];
        self.thermoclineUnit.text = @"m";
        
    }else{
        self.thermocline.text = @"N/A";
        self.thermoclineUnit.text = @"";
    }
    
    
    //display secchiEst
    if(![self.lake.lakeName containsString:@"Mendota"]){
        self.secchiEstPrompt.text = @"";
        self.secchiEst.text = @"";
        self.secchiEstUnit.text = @"";
        
    } else{
        double secchiEstMeter = [self.lake.secchiEst doubleValue];
        if (secchiEstMeter>=-1 ) {
            self.secchiEst.text = [NSString stringWithFormat:@"%.00f", secchiEstMeter];
            self.secchiEstUnit.text = @"m";
        } else {
            self.secchiEst.text = @"N/A";
            self.secchiEstUnit.text = @"";
        }
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

//the method for present the alert information
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
    format.dateFormat = @"MM/dd/yyyy HH:mm";
    return [format stringFromDate:date];
}

//convert the wind, which is represented by the double to a string
-(NSString*) directionForWind: (double) windDir{
    
    if((windDir> 348.75 && windDir<= 360) || (windDir >= 0 && windDir<=11.25)){
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
    } else if (windDir> 326.25 && windDir <= 348.75){
        return @"NNW";
    }
    
    return @"N/A";
    
}

//present the disclaimer over the current page.
- (IBAction)showAbout:(id)sender {
    
    MenuViewController* mvc = [[MenuViewController alloc] init];
    mvc.currentController = self;
    mvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:mvc animated:YES completion:nil];
}


//TODO:
//differnet Modal will have different size font to fit the screen
-(void) changeFontSizeByModal{
    IphoneModelSizeIdentifier* identifier = [[IphoneModelSizeIdentifier alloc] init];
    NSString* modal = [identifier identifyModel:[UIScreen mainScreen]];
    
    // font size for almost all content
    int contentFontSize;
    
    // font size for almost all prompt
    int promptFontSize;
    
    // fonr size for almost unit
    int unitFontSize;
    
    //some specific size
    int thermoAndSeccFontSize;
    int updateTimeFontSize;
    int lakeNameFontSize;
    int windGustFontSize;
    int windGustPromptFontSize;
    int thermoAndSeccUnitFontSize;
    int thermoAndSecchPromptFontSize;
    
    if( [modal isEqualToString:@"iPhone 6Plus"]){
        
        contentFontSize = 58;
        promptFontSize = 28;
        unitFontSize = 28;
        
        lakeNameFontSize = 50;
        thermoAndSeccFontSize = 25;
        updateTimeFontSize = 33;
        windGustFontSize = 24;
        windGustPromptFontSize = 18;
        thermoAndSeccUnitFontSize = 28;
        thermoAndSecchPromptFontSize = 25;
        
    }else if ([modal isEqualToString:@"iPhone 5"]) {
        NSLog(@"This is a iphone 5");
        
        contentFontSize = 44;
        promptFontSize = 23;
        unitFontSize = 25;
        
        lakeNameFontSize = 38;
        thermoAndSeccFontSize = 20;
        thermoAndSeccUnitFontSize = 22;
        updateTimeFontSize = 20;
        windGustFontSize = 22;
        windGustPromptFontSize = 14;
        thermoAndSecchPromptFontSize = 20;
        
    } else if ([modal isEqualToString:@"iPhone 4"]){
         NSLog(@"This is an iPhone 4");
        
        contentFontSize = 36;
        promptFontSize = 22;
        unitFontSize = 22;
        
        lakeNameFontSize = 40;
        thermoAndSeccFontSize = 36;
        thermoAndSeccUnitFontSize = 20;
        thermoAndSecchPromptFontSize = 20;
        updateTimeFontSize = 20;
        windGustFontSize = 22;
        windGustPromptFontSize = 12;
        
    }else if ([modal isEqualToString:@"iPhone 6"]) {
        NSLog(@"This is an iPhone 6");
        
        contentFontSize = 50;
        promptFontSize = 26;
        unitFontSize = 26;
        
        lakeNameFontSize = 46;
        thermoAndSeccFontSize = 50;
        thermoAndSeccUnitFontSize = 23;
        thermoAndSecchPromptFontSize = 23;
        updateTimeFontSize = 25;
        windGustFontSize = 24;
        windGustPromptFontSize = 12;
    }
    
    self.airTemp.font = [UIFont systemFontOfSize:contentFontSize];
    self.windSpeed.font = [UIFont systemFontOfSize:contentFontSize];
    self.waterTemp.font = [UIFont systemFontOfSize:contentFontSize];
    self.thermocline.font = [UIFont systemFontOfSize:contentFontSize];
    self.windDir.font = [UIFont systemFontOfSize:contentFontSize];
    self.secchiEst.font = [UIFont systemFontOfSize:thermoAndSeccFontSize];
    self.windDir.font = [ UIFont systemFontOfSize:contentFontSize];
    self.lakeName.font = [UIFont systemFontOfSize:lakeNameFontSize];
    self.updateTime.font = [UIFont systemFontOfSize:updateTimeFontSize];
    self.windGust.font = [UIFont systemFontOfSize:windGustFontSize];
    
    self.airTempPrompt.font = [UIFont boldSystemFontOfSize:promptFontSize];
    self.waterTempPrompt.font = [UIFont boldSystemFontOfSize:promptFontSize];
    self.WindDirPrompt.font = [UIFont boldSystemFontOfSize:promptFontSize];
    self.windSpeedPrompt.font =[UIFont boldSystemFontOfSize:promptFontSize];
    self.thermoclinePrompt.font = [UIFont boldSystemFontOfSize:thermoAndSecchPromptFontSize];
    self.secchiEstPrompt.font = [UIFont boldSystemFontOfSize:thermoAndSecchPromptFontSize];
    self.windGustPrompt.font =[UIFont systemFontOfSize: windGustPromptFontSize];
    
    self.airTempUnit.font = [UIFont systemFontOfSize:unitFontSize];
    self.waterTempUnit.font = [UIFont systemFontOfSize:unitFontSize];
    self.windSpeedUnit.font = [UIFont systemFontOfSize:unitFontSize];
    self.thermoclineUnit.font = [UIFont systemFontOfSize:thermoAndSeccUnitFontSize];
    self.secchiEstUnit.font = [UIFont systemFontOfSize:thermoAndSeccUnitFontSize];
}

//for other methods to stop the animation of the activity view.
-(void)stopActivityView{
    [self.activityView stopAnimating];
}

@end
