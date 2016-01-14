//
//  Entity.m
//  AppForLiminology View
//
//  Created by Junjie on 16/1/2.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import "Entity.h"

@implementation Entity

// Insert code here to add functionality to your managed object subclass

//Set the temperature for Fahrenheit
-(void)airTempC: (NSNumber*) airTemp{
    
    self.airTempC = airTemp;
    
}

//Set the temperature for Censuis
-(void)airTempF: (NSNumber*) airTemp{
    self.airTempF = [self convertCToF:airTemp];
}

//Convert from F to C
-(NSNumber*) convertCToF: (NSNumber*) cTemp{
    double fTemp = [cTemp doubleValue]*9/5 + 32;
    
    return [NSNumber numberWithDouble:fTemp];
}

-(void) waterTempC:(NSNumber*) waterTemp{
    self.waterTempC = waterTemp;
}

-(void) waterTempF:(NSNumber*) waterTemp{
    self.waterTempF = [self convertCToF:waterTemp];
}


-(NSString*) windDirString{
    
    return nil;
}


@end
