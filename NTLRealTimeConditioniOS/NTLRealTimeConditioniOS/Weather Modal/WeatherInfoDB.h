//
//  WeatherInfoDB.h
//  The database that is reponsible for saving and reading data from the core data database. It is also responsible for setting the homepage
//
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JJWeatherViewController.h"
#import "WeatherDataWebEntrance.h"
#import "Weather.h"
#import "WeatherDBDataEntranceProtocal.h"

@class JJLakeWeather;
@class WeatherDataWebEntrance;
@class JJWeatherViewController;

@protocol WeatherInfoDBDelegate <NSObject>

-(void) weatherInfoDBAfterDataUpdated:(WeatherInfoDB*) db;

@end


@interface WeatherInfoDB : NSObject <NSURLSessionDataDelegate>

// the data for all of the three lakes.
@property (nonatomic,readonly,copy) NSArray* allLakes;
@property (nonatomic,weak) JJWeatherViewController* currentController;

// for checking whether the app has just relaunched. It will be set to true if the app relaunch
//It will be set to false after app has run the first time for app relaunch
@property(nonatomic) BOOL appRelaunch;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic, strong) id<WeatherDBDataEntranceProtocal>dataEntrance;
@property (nonatomic, weak) id<WeatherInfoDBDelegate> delegate;

//The initializer for the database.
//It only allow one databases in the whole program. Singleton as database
+(instancetype) sharedDB;

-(NSString*) itemArchivePath;


//Save the any data updated in the program to the Core data databse
-(BOOL) saveChanges;

// update the lake information, and it will return the weather array
-(NSArray*) loadWeathers;

// These methods are used to test
-(Weather*) createEmptyNewWeather;
-(void) changeLakeData: (NSArray*) jsonArray;

//called by the view controller to set
-(BOOL) homepageToTheFirst;
-(void) checkForOtherHomepage: (NSString*) newlyHomepageLakeName;
-(BOOL) noHomepage;
-(void) startTimer:(int) timeIntervalInSeconds;
-(void) endTimer;

@end
