//
//  Weather+CoreDataProperties.h
//
//  the object that contains the 
//
//  Created by Junjie on 16/1/2.
//  Copyright © 2016年 Junjie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Weather.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

@property ( nonatomic,retain,nullable) NSNumber *airTemp;
@property (nullable, nonatomic, retain) NSNumber *airTempF;
@property (nullable, nonatomic, retain) NSString *lakeId;
@property (nullable, nonatomic, retain) NSString *lakeName;
@property (nullable, nonatomic, retain) NSDate *sampleDate;
@property (nullable, nonatomic, retain) NSDate *secchiEstTimestamp;
@property (nullable, nonatomic, retain) NSNumber *waterTemp;
@property (nullable, nonatomic, retain) NSNumber *waterTempF;
@property (nullable, nonatomic, retain) NSNumber *windDir;
@property (nullable, nonatomic, retain) NSNumber *windSpeed;
@property (nullable,nonatomic,retain)NSNumber * thermoclineDepth;
@property (nullable,nonatomic,retain)NSNumber * phychoMedian;
@property (nullable,nonatomic,retain)NSNumber * secchiEst;
@property (nullable,nonatomic,retain)UIImage* windDirImage;
@property (nullable,nonatomic,retain)NSNumber* favourite;
@property (nullable,nonatomic,retain) NSNumber* windGust;

@end

NS_ASSUME_NONNULL_END
