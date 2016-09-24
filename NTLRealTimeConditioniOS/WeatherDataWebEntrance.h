//
//  WeatherDataWebEntrance.h
//  Get data from the web, and then send it to its delegate, weather info database
//  If no network connection is on, send a notification to the view controller
//  that the network is not one

//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 8/2/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfoDB.h"  
#import "WeatherDBDataEntranceProtocal.h"

@class WeatherInfoDB;

@interface WeatherDataWebEntrance : NSObject <WeatherDBDataEntranceProtocal>
@property (nonatomic, strong) id delegate;
@property (nonatomic, readonly) BOOL isNetworkOn;

-(void) getWeatherData;
-(instancetype) initWithDatabase: (WeatherInfoDB*) db;


@end
