//
//  JJLakeWeather.h
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJLakeWeather : NSObject


@property (nonatomic) NSString* name;
@property (nonatomic) NSString* ID;
@property (nonatomic) double airTempF;
@property (nonatomic) double airTempC;
@property (nonatomic) double windSpeed;
@property (nonatomic) double windDir;
@property (nonatomic) double thermochline;
@property (nonatomic) double waterTempF;
@property (nonatomic) double waterTempC;
@property (nonatomic) double PhycoMedian; // only for Lake Mendota, and no need to display
@property (nonatomic) double secchiEst; //only for Lake Mendota
@property (nonatomic) NSDate* sampleDate;
@property (nonatomic) NSDate* sEDate; // only for Lake Mendota

-(instancetype) initWithName:(NSString*) name
                      withID: (NSString*) Id
                  withAirTmp:(double) airTemp
               withwindSpeed:(double) speed
                     withDir: (double) windDirection
            withThermochline: (double) thermochline
               withWaterTemp: (double) waterTemp
                   withStamp: (NSDate*) date
             withPhycoMedian: (double) phychoMedian
                withSecchiEst: (double) secchiEst
           withSecchiEstDate:(NSDate*) sEDate;


-(instancetype) initWithName:(NSString*) name
                      withID: (NSString*) Id
                  withAirTmp:(double) airTemp
               withwindSpeed:(double) speed
                     withDir: (double) windDirection
            withThermochline: (double) thermochline
               withWaterTemp: (double) waterTemp
                   withStamp: (NSDate*) date;





@end
