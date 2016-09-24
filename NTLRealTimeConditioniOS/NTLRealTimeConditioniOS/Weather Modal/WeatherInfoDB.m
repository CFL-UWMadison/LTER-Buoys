//
//  WeatherInfoDB.m
//  AppForLiminology View
//
//  By using the Notification center might be a good way to update the data. As long as db
//  receives a notification, it will update the data.
//
//  I need to better understand the nil message problem. I remember it will not cause null pointer.
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "WeatherInfoDB.h"
@import CoreData;
#import "Weather.h"
#import "WeatherDataWebEntrance.h"
#import "WeatherPropertyModifier.h"

@class WeatherDataWebEntrance;
@class WeatherPropertyModifier;
NSString* const serverURL = @"";

@interface WeatherInfoDB ()

@property (nonatomic) NSMutableArray* privateLakeWeathers;
@property(nonatomic,strong) NSManagedObjectContext *localStoreContext;
@property(nonatomic,strong) NSManagedObjectModel *weatherCoreDataModel;
@property (nonatomic) int hardCodeLakeNum; // I forgot when I did this.....
@property (nonatomic, strong) WeatherPropertyModifier* modifier;

@end


@implementation WeatherInfoDB

//there is only one database in the whole program. Singleton
+(instancetype) sharedDB{
    static WeatherInfoDB* db;
    if(!db){
        db = [[self alloc] initPrivate];
    }
    return db;
}

-(instancetype) init{
    return [WeatherInfoDB sharedDB];
}

/*
-(instancetype) initWhenFirstLaunch{
    self.appRelaunch = YES;
    [self fetchDataIfAppRelaunch];
    
}*/

//Override the accessor, let the allLakes to a private immutable array
-(NSArray*) allLakes{
    return [self.privateLakeWeathers copy];
}



//This is the private method for initializing the database. It's a part of the singleton design
-(instancetype) initPrivate{
    self = [super init];
    if (self) {
        
        NSPersistentStoreCoordinator* psc = [self initializePerisistentStoreCoordinator];
        // this psc will be used to hold the infomation about the local store
        // it will be used for the initialization of the model context
        
        NSURL *localPersistanceURL = [NSURL fileURLWithPath:self.itemArchivePath];
        // This path is the relative path for the program to find the database in the bundle
        // The path needs to be changed everytime I change the model
        
        [self addLocalStoreToCooridinator:psc WithStoreURL:localPersistanceURL];
        
        _localStoreContext = [self initializeAContextWithCooridinator:psc];
        // This context will be used throughout the database to read and save data to the local
        // store
        
        self.dataEntrance = [[WeatherDataWebEntrance alloc] initWithDatabase:self];
        // This entrance will be used to fetch data from the outside.
        
        _modifier = [[WeatherPropertyModifier alloc] init];
        // This modifier will be responsible for assigning the data from the json string object to the
        // the Weather object.
        
        _hardCodeLakeNum = 3;
        
        // This will set this db to respond to the update data notification
        // to update the data
        [self addUpdateDataNotificationReceiver];
    
        self.appRelaunch = YES;
        [self fetchDataIfAppRelaunch];
        
    }
    
    NSLog(@"**** The database has been created successfully ****");
    
    return  self;
}

- (NSPersistentStoreCoordinator*) initializePerisistentStoreCoordinator{
    _weatherCoreDataModel =[NSManagedObjectModel mergedModelFromBundles:nil];
    return [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_weatherCoreDataModel];
}

//This will return where does the local file store. You should be able to change the string
//to store the data
-(NSString*) itemArchivePath{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and the only document directory from that list
    NSString* documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"NTLLakeConditionV1.1.4.2.data"];
}

- (void) addLocalStoreToCooridinator: (NSPersistentStoreCoordinator*) psc WithStoreURL:(NSURL*)
localPersistanceURL{
    NSError* error;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localPersistanceURL options:nil error:&error]) {
        [NSException raise:@"Open fail" format:[error localizedDescription]];
    }
}

-(NSManagedObjectContext*) initializeAContextWithCooridinator: (NSPersistentStoreCoordinator*) psc{
    
    // initialize the new context
    NSManagedObjectContext* tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // add the persistent store coordinator
    tempContext.persistentStoreCoordinator = psc;
    return tempContext;
}

-(void) addUpdateDataNotificationReceiver{
    // The object at the end should be set to nil, or this observer will stop working.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:(@selector(receiveUpdateNotification:)) name:@"DataNeedsUpdateNotification" object:nil];
}

-(void) receiveUpdateNotification:(NSNotification*) note{
    // as long as it receives this notification, the db will update the data. And Logically it will update
    // the data on the screen
    
    NSLog(@"**** The database has been notified to update the lake data ****");
    
    [self loadWeathers];
}

// Should only be called when the app get launched (which means after user has killed the process)
-(void) fetchDataIfAppRelaunch{
    if (self.appRelaunch){
        _privateLakeWeathers = [self getLakesFromLocalPersistance:self.localStoreContext];
        self.appRelaunch = NO;
    }
}

-(NSMutableArray*) getLakesFromLocalPersistance:(NSManagedObjectContext*) context{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:self.localStoreContext];
    request.entity = entity;
    NSError* error;
    NSArray* result = [self.localStoreContext executeFetchRequest:request error:&error];
    return [NSMutableArray arrayWithArray:result];
}



// this timer is used to auto refresh the database in a specific time. I'm thinking about change
// the startTimer to receive an parameter
-(void) startTimer:(int) timerIntervalInSeconds{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerIntervalInSeconds target:self selector:@selector(autoRefresh:) userInfo:nil repeats:YES];
    
    NSLog(@"**** The timer in the weather database has been set to 60 seconds and get started ****");
}

-(void) endTimer{
    [self.timer invalidate];
}

-(void) autoRefresh:(NSTimer*) timer{
    [self loadWeathers];
    
    NSLog(@"**** The database has autorefreshed. ****");
    
    return;
}



//load the weather
-(NSArray*) loadWeathers{
    
    // At the very first launch of the app, there might be no data
    // So check whether there is anything in the persistance database
    // If not, I used a placeholder data to initialize the database
    if(_privateLakeWeathers.count != self.hardCodeLakeNum)
        [self insertNewWeatherToDB];
    
    // After the web entrance gets the data, it will execute a method to update the
    // data inside this class
    [self.dataEntrance getWeatherData];

    //Save the change to the local database
    if(![self saveChanges]){
        [NSException raise:@"SaveFailure" format:@"Something goes wrong with the core data saving"];
    }
    
    // return the copy of the lake
    return [self allLakes];
}

-(BOOL) saveChanges{
    NSError* error;
    BOOL done = [self.localStoreContext save:&error];
    if(!done){
        NSLog(@"**** Saving isn't successful: %@ ****", [error localizedDescription]);
    }
    NSLog(@"**** The save to the local database is successful. ****");
    
    return done;
}

// Insert new entities to the database if the local data
// file gets created. This method should only be called under these two scenarios
// 1: It's the first time the user uses this app
// 2: The developer has changed the name of the local data file, which enforces the app to create a new local db
// It will initialize a placeholder hard coded in the place holder.
-(void) insertNewWeatherToDB{
    
    NSArray* jsonArray = [self dataPlaceHolder];
    self.privateLakeWeathers = [self createWeathers:jsonArray];
}

-(NSArray*) dataPlaceHolder{
    NSString* placeHolderString =  @"[{\"airTemp\":9.9,\"lakeId\":\"ME\",\"lakeName\":\"Lake Mendota\",\"phycoMedian\":386.46,\"sampleDate\":\"2016-05-10T19:45:55\",\"secchiEst\":2.24,\"secchiEstTimestamp\":\"2016-05-10T19:00:00\",\"thermoclineDepth\":null,\"waterTemp\":10.0,\"windDir\":107,\"windSpeed\":4.9},{\"airTemp\":11.6,\"lakeId\":\"SP\",\"lakeName\":\"Sparkling Lake\",\"sampleDate\":\"2016-05-10T19:00:00\",\"thermoclineDepth\":5.56,\"waterTemp\":11.42,\"windDir\":106,\"windSpeed\":2.2},{\"airTemp\":17.0,\"lakeId\":\"TR\",\"lakeName\":\"Trout Lake\",\"sampleDate\":\"2015-11-03T15:41:00\",\"thermoclineDepth\":7.51,\"waterTemp\":9.7,\"windDir\":142,\"windSpeed\":2.4}]";
    NSData* data = [placeHolderString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return jsonArray;
}

-(NSMutableArray*) createWeathers: (NSArray*) dummyWeathers{
    NSMutableArray* weatherArray= [[NSMutableArray alloc] init];
    
    for (NSDictionary* dummyWeather in dummyWeathers) {
        [weatherArray addObject: [self createNewLakeWeatherWithInfo:dummyWeather]];
    }
    return weatherArray;
}

-(Weather*) createNewLakeWeatherWithInfo: (NSDictionary*) dummyWeather{
    Weather* weatherNew= [self createEmptyNewWeather];
    
    // These two aren't get assigned in the assignPropertyToWeather method
    weatherNew.lakeName = [dummyWeather objectForKey:@"lakeName"];
    weatherNew.lakeId = [dummyWeather objectForKey:@"lakeId"];
    weatherNew= [self assignPropertyToWeather:weatherNew FromJsonObject:dummyWeather];
    return weatherNew;
}

// This method will use the WeatherPropertyModifer to assign the value from the website
// to the value in the current database lakes.
// @return: the original weather but with the new data.
-(Weather*) assignPropertyToWeather:(Weather*)weatherTmp FromJsonObject:jsonObject{
    weatherTmp = [self.modifier modificationFromJSONSource:jsonObject ToTargetWeather:weatherTmp];
    return weatherTmp;
}

// The new method will be created by the managed object context
-(Weather*) createEmptyNewWeather{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:self.localStoreContext];
}



// This method will get process the data returned from web entrance, and start the chain of
// modify the current data in the memeory and ask the delegate to respond
- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [self changeLakeData:jsonArray];
    NSLog(@"**** The data has been received through the network. ****");
}

-(void) changeLakeData: (NSArray*) jsonArray {
    // This will go through the jsonArray to assign the data
    [self modifyEachLakeDataBasedOnNewJsonArray:jsonArray];
    
    [self callDelegateToRespondToDataChange: self.delegate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentController.unconnected = NO;
        [self.currentController displayData];
    });
}

-(void) modifyEachLakeDataBasedOnNewJsonArray:(NSArray*) jsonArray{
    if(jsonArray){
        for (NSDictionary* jsonObject in jsonArray) {
            [self modifyOneLakeDataFromJsonObject:jsonObject];
        }
    }
}

-(void) modifyOneLakeDataFromJsonObject:(NSDictionary*) jsonObject{
    Weather* weatherBeingModified = [self findWeatherByName:[jsonObject objectForKey:@"lakeName"] orID:[jsonObject objectForKey:@"lakeId"] inWeatherArray:self.privateLakeWeathers];
    weatherBeingModified = [self assignPropertyToWeather:weatherBeingModified FromJsonObject:jsonObject];
}

-(Weather*) findWeatherByName:(NSString*) name orID:(NSString*)iD inWeatherArray: (NSMutableArray*) weatherArray{
    for (int i =0; i<weatherArray.count; i++) {
        Weather* weatherTmp = [weatherArray objectAtIndex:i];
        if ([weatherTmp.lakeName isEqualToString:name]|| [weatherTmp.lakeId isEqualToString:iD]) {
            return weatherTmp;
        }
    }
    return nil;
}

-(void) callDelegateToRespondToDataChange:(id<WeatherInfoDBDelegate>) delegate{
    if (delegate){
        [delegate weatherInfoDBAfterDataUpdated:self];
    }else {
        NSLog(@"No delegate has been assigned to this weatherInfoDB");
        @throw [NSException exceptionWithName:@"NoDelegateException" reason:@"No delegate has been assigned to this weatherInfoDB" userInfo:nil];
    }
}



// I probably need to put this one to the Weather Property Modifier
-(UIImage*) imageOfwindDir:(Weather*) weatherTmp{
    NSString* urlString;
    if([weatherTmp.lakeName containsString:@"Sparkling"]){
        urlString = @"http://144.92.62.213/images/SP/SP_WindDir.jpeg";
    }
    else if([weatherTmp.lakeName containsString:@"Trout"]){
        urlString = @"http://144.92.62.213/images/TR/TR_WindDir.jpeg";
    }

    NSURL* url = [NSURL URLWithString:urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:url];
    if(!imageData){
        return nil;
    }
    
    UIImage* windDir = [UIImage imageWithData:imageData];
    return windDir;
    
}

/*
 This method is a private function which is used to convert the string of the date to the NSDate
 The original input should be like 2015-11-07T17:10:00
 */
/*
-(NSDate*) convertStringToDate: (NSString*) dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //HH:mm:ss
    NSDate* date =[[NSDate alloc] init];
    
    date = [dateFormat dateFromString:dateString];
    return date;
}*/

/*
-(NSNumber*) convertCToF: (NSNumber*) cTemp{
    double fTemp = [cTemp doubleValue]*9/5 + 32;
    
    return [NSNumber numberWithDouble:fTemp];
}*/

// Let's see, how do I change these codes?
//put the homepage lake to the front, called in AppleDelegate

// Now if this method returns YES, it means there exists a homepage and it gets done
// If this method return NO, it means there exists no homepage
-(BOOL)homepageToTheFirst{
    
    if ([self noHomepage]){
        return NO;
    }
    
    //change the order of the array by the favourite
    for (int i =0; i<_privateLakeWeathers.count; i++) {
        Weather* weather = [_privateLakeWeathers objectAtIndex:i];
        if([self weatherIsHomepage:weather] && i!= 0){
            NSLog(@"The favourite lake is %@", weather.lakeName);
            _privateLakeWeathers[i] = _privateLakeWeathers[0];
            _privateLakeWeathers[0] = weather;
        }
    }
    [self saveChanges];
    return YES;
}

-(BOOL) weatherIsHomepage:(Weather*) weather{
    return [weather.lakeId isEqualToString:[self getUserSettingHomepage]];
}

-(NSString*) getUserSettingHomepage{
    UserSetting* userSetting = [UserSetting sharedSetting];
    return userSetting.homepage;
}

-(BOOL) noHomepage{
    return [[self getUserSettingHomepage] isEqualToString:@"None"];
}

//Called in WeatherViewController
/*
-(void) checkForOtherHomepage: (NSString*) newlyFavouriteLakeName{
    for (int i =0; i< _privateLakeWeathers.count;i++){
        Weather* tmp = [_privateLakeWeathers objectAtIndex:i];
        if(![tmp.lakeName isEqualToString:newlyFavouriteLakeName]){
            tmp.favourite = [NSNumber numberWithBool:NO];
        }
    }
    [self saveChanges];
}
 */

@end
