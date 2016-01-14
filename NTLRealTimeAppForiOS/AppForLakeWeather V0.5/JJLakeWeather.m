//
//  JJLakeWeather.m
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

/*Journal 12/27
 I decide the model should have the raw data from the website. The scale things can be done in the database or in the view
 
*/
#import "JJLakeWeather.h"


@implementation JJLakeWeather


-(instancetype) initWithName:(NSString *)name withID:(NSString *)Id withAirTmp:(double)airTempC withwindSpeed:(double)speed withDir:(double)windDirection withThermochline:(double)thermochline withWaterTemp:(double)waterTemp withStamp:(NSDate *)date{
    
    self = [self initWithName:name withID:Id withAirTmp:airTempC withwindSpeed:speed withDir:windDirection withThermochline:thermochline withWaterTemp:waterTemp withStamp:date withPhycoMedian:0 withSecchiEst:0 withSecchiEstDate:NULL];
    
    return  self;
}

//For the lake Mendota, since it has two things that the others doesn't have
-(instancetype) initWithName:(NSString *)name withID:(NSString *)Id withAirTmp:(double)airTempC withwindSpeed:(double)speed withDir:(double)windDirection withThermochline:(double)thermochline withWaterTemp:(double)waterTemp withStamp:(NSDate *)date withPhycoMedian:(double)phychoMedian withSecchiEst:(double)secchiEst withSecchiEstDate:(NSDate *)sEDate {
    
    self = [[JJLakeWeather alloc] init];
    if(self){
        self.name = name;
        self.ID = Id;
        self.airTempC = airTempC;
        self.airTempF = airTempC;
        self.windSpeed = speed;
        self.windDir = windDirection;
        self.PhycoMedian = phychoMedian;
        self.waterTempC = waterTemp;
        self.waterTempF = waterTemp;
        self.sampleDate = date;
        self.thermochline = thermochline;
        self.sEDate = sEDate;
        return self;
    }
    return nil;
}




//Set the temperature for Fahrenheit
-(void)airTempC: (double) airTemp{
    _airTempC = airTemp;
    
}

//Set the temperature for Censuis
-(void)airTempF: (double) airTemp{
    _airTempF = [self convertCToF:airTemp];
}

//Convert from F to C
-(double) convertCToF: (double) fTemp{
    return  self.airTempC * 9/5 + 32;
}

-(void) waterTempC:(double) waterTemp{
    _waterTempC = waterTemp;
}

-(void) waterTempF:(double) waterTemp{
    _waterTempF = [self convertCToF:waterTemp];
}



-(NSString*) windDirString{
    return nil;
}


@end
