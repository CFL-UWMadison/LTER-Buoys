//
//  WeatherDBDataEntrance.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/5/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "WeatherDBDataEntrance.h"
#import "WeatherInfoDB.h"

@implementation WeatherDBDataEntrance

- (instancetype) init{
    self = [self initWithDatabase:nil];
    return self;
}

-(instancetype) initWithDatabase: (WeatherInfoDB*) db{
    self = [super init];
    if (self) {
        self.delegate = db;
    }
    return self;
}


-(NSString*) getDataServiceURL{
    return @"http://thalassa.limnology.wisc.edu:8080/LakeConditionService/webapi/lakeConditions";
}


@end
