//
//  UnitConverter.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 6/26/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "UnitConverter.h"


@implementation UnitConverter

+(NSNumber*)fToC:(NSNumber *)faran{
    double f = [faran doubleValue];
    double c = (f - 32)/1.8;
    
    
    return [[NSNumber alloc] initWithDouble:c];
}


+(NSNumber *)cToF:(NSNumber *)cele{
    double c = [cele doubleValue];
    double f = c*1.8 + 32;
    return [[NSNumber alloc] initWithDouble:f];
}

+(NSNumber*) feetToM:(NSNumber *)feet{
    double f = [feet doubleValue];
    double m = f/3.2808;
    
    return [[NSNumber alloc] initWithDouble:m];
}

+ (NSNumber *)mToFeet:(NSNumber *)meter{
    double m = [meter doubleValue];
    double f = m * 3.2808;
    
    return [[NSNumber alloc] initWithDouble:f];
    
}

+(NSNumber*) msToMph:(NSNumber *)ms{
    double msD = [ms doubleValue];
    double mph = msD/0.44;
    
    return [[NSNumber alloc] initWithDouble:mph];
}

+ (NSNumber *)mphToMs:(NSNumber *)mph{
    double mphD = [mph doubleValue];
    double ms = mphD * 0.44;
    
    return [[NSNumber alloc] initWithDouble:ms];
}

@end
