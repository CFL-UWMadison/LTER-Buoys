//
//  WeatherPropertyModifier.h
//
//  This modifier 
//
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 8/14/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"


@interface WeatherPropertyModifier : NSObject

// This method is used to assign the new data from the json source into the corresponding
// property in a weather
-(Weather*) modificationFromJSONSource: (NSDictionary*) jsonSource ToTargetWeather: (Weather*) weather;

@end
