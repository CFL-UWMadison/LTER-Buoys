//
//  UnitConverter.h
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 6/26/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitConverter : NSObject

+(NSNumber*) fToC:(NSNumber*) faran;
+(NSNumber*) cToF:(NSNumber*) cele;
+(NSNumber*) msToMph:(NSNumber*) ms;
+(NSNumber*) mphToMs:(NSNumber*) mph;
+(NSNumber*) feetToM: (NSNumber*) feet;
+(NSNumber*) mToFeet:(NSNumber*) meter;

@end
