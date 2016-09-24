//
//  WeatherPropertyModifier.m
//  NTLRealTimeConditioniOS
//
//  This class is a utility class tool for the developer to update the
//  Weather, an object managed by the core data with the incoming data in json form
//
//  !!!!Be aware that this class can only if and only if the properties in the coredata model
//  (Weather.xcdatamodeld) have the same name with the incoming json object property key name.
//
//  Created by Junjie on 8/14/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "WeatherPropertyModifier.h"
#import "Weather.h"

@class Weather;

@interface WeatherPropertyModifier ()

@property NSArray* allLakeSharedKeys;
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
        
        // These properties are available for all of the lakes.
        _allLakeSharedKeys = @[@"airTemp",@"waterTemp",@"windDir", @"windSpeed", @"thermoclineDepth", @"sampleDate"];
        
        // These properties are only assigned to this specified lake
        _keysForSpecificLake = @{
                                 @"ME": @[@"phycoMedian", @"secchiEst",
                                @"secchiEstTimestamp"]
                                 };
        
        // If the key is in this array, it will call another function to transform the string
        // to the date
        _keysForDate = @[@"sampleDate", @"secchiEstTimestamp"];
        
    }
    return self;
}

-(Weather*) modificationFromJSONSource: (NSDictionary*) jsonSource ToTargetWeather: (Weather*) weather{
    
    NSLog(@"****The modfication gets started for %@ ******", weather.lakeName);
    self.jsonSource = jsonSource;
    self.target = weather;
    
    [self assignPropertiesForKeys: self.allLakeSharedKeys];
    [self processKeysForSpecificLake];
    
    return self.target;
}

-(void) assignPropertiesForKeys: (NSArray*) keys {
    for (NSString *key in keys) {
        if ([self isKeyForDate:key]){
            [self processDateKey:key];
        } else {
            [self normalAssignmentWithKey:key];
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

-(void) processDateKey: (NSString*) key{
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

-(void) normalAssignmentWithKey:(NSString*) key{
    
    // This uses a dynamic way of setting the property. Search that on google
    id jsonSourceProperty = [_jsonSource objectForKey:key];
    
    if(jsonSourceProperty == [NSNull null]){
        [self.target setValue:[NSNumber numberWithDouble:999] forKey:key];
    }else{
        [self.target setValue:jsonSourceProperty forKey:key];
    }
    //NSLog(@"**** Debug for modification: %@: %@", key, [self.target valueForKey:key]);
}

-(void) processKeysForSpecificLake{
    for (NSString *lakeid in self.keysForSpecificLake){
        
        if ([self targetidIsIdenticalWithLakeid:lakeid]){
            NSArray* keys = [_keysForSpecificLake objectForKey:lakeid];
            [self assignPropertiesForKeys:keys];
            
        }
    }
}

-(BOOL) targetidIsIdenticalWithLakeid: (NSString*) lakeid{
    return [self.target.lakeId isEqualToString:lakeid];
}

@end
