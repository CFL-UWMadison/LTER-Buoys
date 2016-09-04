//
//  WeatherPropertyModifier.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 8/14/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "WeatherPropertyModifier.h"
#import "Weather.h"

@class Weather;

@interface WeatherPropertyModifier ()

@property NSArray* normalKeys;
@property NSDictionary* keysForSpecificLake;
@property NSArray* keysForDate;

@property Weather* target;
@property NSDictionary* jsonSource;


@end

@implementation WeatherPropertyModifier

-(instancetype) init{
    self = [super init];
    
    if (self){
        // The keys will be a dictionary. The key is the json object field and
        // the value will be the property of the Weather object
        // The json object field can be found on the website and the property of the Weather
        // object can be found in the Weather files
        
        // TODO in the future: probably makes the Weather properties the same as the json object
        // This can be risky because if the 
        
        _normalKeys = @[@"airTemp",@"waterTemp",@"windDir", @"windSpeed", @"thermoclineDepth", @"sampleDate"];
        
        _keysForSpecificLake = @{
                                 @"ME": @[@"phychoMedian", @"secchiEst",
                                @"secchiEstTimestamp"]
                                 };
        
        // If the key is in this array, it will call another function to transform the string
        // to the date
        _keysForDate = @[@"sampleDate", @"secchiEstTimestamp"];
        
    }
    return self;
}

-(Weather*) modificationFromJSONSource: (NSDictionary*) jsonSource ToTargetWeather: (Weather*) weather{
 
    self.jsonSource = jsonSource;
    self.target = weather;
    
    [self assignPropertyForKeys: self.normalKeys];
    [self processKeysForSpecificLake];
    
    return self.target;
}

-(void) assignPropertyForKeys: (NSArray*) keys {
    for (NSString *key in keys) {
        if ([self isKeyForDate:key]){
            [self processDateKey:key];
        } else {
            [self normalAssignmentWithKey:key];
        }
    }
}

-(void) normalAssignmentWithKey:(NSString*) key{
    
    // This uses a dynamic way of setting the property
    id jsonSourceProperty = [_jsonSource objectForKey:key];
    
    if(jsonSourceProperty == [NSNull null]){
        [self.target setValue:[NSNumber numberWithDouble:999] forKey:key];
    }else{
        [self.target setValue:jsonSourceProperty forKey:key];
    }
}

-(void) processKeysForSpecificLake{
    for (NSString *lakeid in self.keysForSpecificLake){
        
        if ([self targetidIsIdenticalWithLakeid:lakeid]){
            NSArray* keys = [_keysForSpecificLake objectForKey:lakeid];
            [self assignPropertyForKeys:keys];
            
        }
    }
}

-(BOOL) isKeyForDate: (NSString*) keyForCheck{
    for (NSString* key in self.keysForDate){
        if ( [key isEqualToString:keyForCheck]){
            return YES;
        }
    }
    return NO;
}

-(BOOL) targetidIsIdenticalWithLakeid: (NSString*) lakeid{
    return [self.target.lakeId isEqualToString:lakeid];
}

- (void) processDateKey: (NSString*) key{
    NSDate* propertyInDate = [self convertStringToDate: (NSString*)[self.jsonSource objectForKey:key]];
    [self.target setValue:propertyInDate forKey: key];
}

-(NSDate*) convertStringToDate: (NSString*) dateString{
    
    // set up the dateFormat
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //HH:mm:ss
    
    // convert to the date
    NSDate* date =[[NSDate alloc] init];
    date = [dateFormat dateFromString:dateString];
    return date;
}


@end
