//
//  Entity+CoreDataProperties.h
//  AppForLiminology View
//
//  Created by Junjie on 16/1/2.
//  Copyright © 2016年 Junjie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property ( nonatomic,retain,nullable) NSNumber *airTempC;
@property (nullable, nonatomic, retain) NSNumber *airTempF;
@property (nullable, nonatomic, retain) NSString *iD;
@property (nullable, nonatomic, retain) NSString *lakeName;
@property (nullable, nonatomic, retain) NSDate *sampleDate;
@property (nullable, nonatomic, retain) NSDate *sEDate;
@property (nullable, nonatomic, retain) NSNumber *waterTempC;
@property (nullable, nonatomic, retain) NSNumber *waterTempF;
@property (nullable, nonatomic, retain) NSNumber *windDir;
@property (nullable, nonatomic, retain) NSNumber *windSpeed;
@property (nullable,nonatomic,retain)NSNumber * thermocline;
@property (nullable,nonatomic,retain)NSNumber * phychoMedian;
@property (nullable,nonatomic,retain)NSNumber * secchiEst;

@end

NS_ASSUME_NONNULL_END
