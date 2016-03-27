//
//  WeatherInfoDB.h
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JJLakeWeather;

@interface WeatherInfoDB : NSObject

@property (nonatomic,readonly,copy) NSArray* allLakes;

//The initializer for the database.
//It only allow one databases in the whole program.
+(instancetype) sharedDB;

//This method update the Weather from Argyron server.
-(NSString*) itemArchivePath;
-(BOOL) saveChanges;
-(void) loadWeathers;
-(void)homepageToTheFirst;
-(void) checkForOtherHomepage: (NSString*) newlyHomepageLakeName;
-(BOOL)noHomepage;
@end
