//
//  WeatherInfoDB.m
//  AppForLiminology View
//
//  Created by Junjie on 15/12/27.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "WeatherInfoDB.h"
@import CoreData;
#import "Weather.h"

@interface WeatherInfoDB ()
@property (nonatomic) NSMutableArray* privateLakeWeathers;
@property(nonatomic,strong) NSManagedObjectContext *context;
@property(nonatomic,strong) NSManagedObjectModel *model;

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

//Override the accessor, let the allLakes to a private immutable array
-(NSArray*) allLakes{
    return [self.privateLakeWeathers copy];
}

//This is the private
-(instancetype) initPrivate{
    self = [super init];
    if (self) {
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString* path = self.itemArchivePath;
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSError* error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            [NSException raise:@"Open fail" format:[error localizedDescription]];
        }
    
        //initialize the context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        [self loadWeathers];
    }
    return  self;
}

-(BOOL) saveChanges{
    NSError* error;
    BOOL done = [self.context save:&error];
    if(!done){
        NSLog(@"Saving isn't successful: %@", [error localizedDescription]);
    }
    return done;
}

//load the weather
-(void) loadWeathers{
    
    //Fetch the data from the local file
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:self.context];
    request.entity = entity;
    NSError* error;
    NSArray* result = [self.context executeFetchRequest:request error:&error];
    _privateLakeWeathers = [NSMutableArray arrayWithArray:result];
    
    //Decide whether the lake should
    if(_privateLakeWeathers.count !=3){
        self.privateLakeWeathers = [self insertNewWeatherToDB];
    }else{
        self.privateLakeWeathers = [self updateWeathersFromWeb:self.privateLakeWeathers];
    }
    
    //save the change to the file
    if(![self saveChanges]){
        [NSException raise:@"SaveFailure" format:@"Something goes wrong with the core data saving"];
    }
}

//insert new entities to the local db
-(NSMutableArray*) insertNewWeatherToDB{
    NSArray* jsonArray = [self getDataFromArgyron];
    NSMutableArray* weatherArray= [[NSMutableArray alloc] init];
    
    for (int i =0; i< jsonArray.count; i++) {
        //create the new neity
        Weather* weatherNew= [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:self.context];
        NSDictionary* jsonObject = [jsonArray objectAtIndex:i];
        weatherNew.lakeName = [jsonObject objectForKey:@"lakeName"];
        weatherNew.iD = [jsonObject objectForKey:@"lakeId"];
        weatherNew= [self assignPropertyToWeather:weatherNew FromJsonObject:jsonObject];
        [weatherArray addObject:weatherNew];
        weatherNew.favourite = [NSNumber numberWithBool:NO];
        NSLog(@"%d", [weatherNew.favourite boolValue]);
    }
    return weatherArray;
}

-(NSMutableArray*) updateWeathersFromWeb:(NSMutableArray*) dataNeededModified{
    NSArray* jsonArray = [self getDataFromArgyron];
    
    //if no internet, use the old data.
    if(!jsonArray){
        return dataNeededModified;
    }
    
    for (int i =0; i<jsonArray.count; i++) {
        NSDictionary* jsonObject = [jsonArray objectAtIndex:i];
        Weather* weatherBeingModified = [self findWeatherByName:[jsonObject objectForKey:@"lakeName"] orID:[jsonObject objectForKey:@"lakeId"] inWeatherArray:dataNeededModified];
        weatherBeingModified = [self assignPropertyToWeather:weatherBeingModified FromJsonObject:jsonObject];
    }
    NSLog(@"The data has been updated");
    
    return dataNeededModified;
}

-(Weather*) findWeatherByName:(NSString*) name orID:(NSString*)iD inWeatherArray: (NSMutableArray*) weatherArray{
    for (int i =0; i<weatherArray.count; i++) {
        Weather* weatherTmp = [weatherArray objectAtIndex:i];
        if ([weatherTmp.lakeName isEqualToString:name]|| [weatherTmp.iD isEqualToString:iD]) {
            return weatherTmp;
        }
    }
    return nil;
}


-(NSArray*) getDataFromArgyron{
    /*NSString* filePath = @"/Users/xu/Desktop/软件/AppForLakeWeather V0.5/AppForLakeWeather V0.5/TestJson.txt";
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    */
    NSString* urlString =@"http://thalassa.limnology.wisc.edu:8080/LakeConditionService/webapi/lakeConditions";
    NSURL* url = [NSURL URLWithString:urlString];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    NSArray* jsonArray;
    if(data){
        jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }else{
        jsonArray = nil;
    }
    return jsonArray;
}

-(Weather*) assignPropertyToWeather:(Weather*)weatherTmp  FromJsonObject:jsonObject{
    
    //assign air temperature
    if([jsonObject objectForKey:@"airTemp"] == [NSNull null]){
        weatherTmp.airTempC = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.airTempC = [jsonObject objectForKey:@"airTemp"];
    }
    
    //assign water temperature
    if([jsonObject objectForKey:@"waterTemp"]== [NSNull null] ){
            weatherTmp.waterTempC = [NSNumber numberWithDouble:999];
         }else{
            weatherTmp.waterTempC = ([jsonObject objectForKey:@"waterTemp"]);
    }
    
    //assign wind direction
    if([jsonObject objectForKey:@"windDir"]== [NSNull null]){
        weatherTmp.windDir = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.windDir = [jsonObject objectForKey:@"windDir"];
    }
    
    //assign the image of the wind direction
    if([weatherTmp.windDir doubleValue] >=0 && [weatherTmp.windDir doubleValue]<= 360 && [self imageOfwindDir:weatherTmp]){
        weatherTmp.windDirImage = [self imageOfwindDir:weatherTmp];
    }else{
        weatherTmp.windDirImage = nil;
    }
    
    //assign the wind speed
    if([jsonObject objectForKey:@"windSpeed"] == [NSNull null]){
        weatherTmp.windSpeed = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.windSpeed = [jsonObject objectForKey:@"windSpeed"];
    }
    
    //assign the thermocline depth
    if([jsonObject objectForKey:@"thermoclineDepth"] == [NSNull null]){
        weatherTmp.thermocline = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.thermocline = [jsonObject objectForKey:@"thermoclineDepth"];
    }
    
    //assign the fahrenheit air temperature
    if([weatherTmp.airTempC doubleValue] == -999){
        weatherTmp.airTempF = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.airTempF = [self convertCToF:weatherTmp.airTempC];
    }
    
    //assign the fehrenheit water temperture
    if([weatherTmp.waterTempC doubleValue] == 999){
        weatherTmp.waterTempF = [NSNumber numberWithDouble:999];
    }else{
        weatherTmp.waterTempF =[self convertCToF:weatherTmp.waterTempC];
    }
    
    weatherTmp.sampleDate = [self convertStringToDate:[jsonObject objectForKey:@"sampleDate"]];
    
    
    //assign the time stamp
    weatherTmp.sampleDate = [self convertStringToDate:[jsonObject objectForKey:@"sampleDate"]];
    if([weatherTmp.lakeName containsString:@"Mendota"]){
        // Set the special property for lake Mendota
        weatherTmp.phychoMedian = [jsonObject objectForKey:@"phychoMedian"];
        weatherTmp.secchiEst = [jsonObject objectForKey:@"secchiEst"];
        weatherTmp.sEDate= [self convertStringToDate:[jsonObject objectForKey:@"secchiEstTimestamp"]];
    }
    
    return weatherTmp;
}


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
-(NSDate*) convertStringToDate: (NSString*) dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //HH:mm:ss
    NSDate* date =[[NSDate alloc] init];
    date = [dateFormat dateFromString:dateString]; //17:00:00
    return date;
}

-(NSNumber*) convertCToF: (NSNumber*) cTemp{
    double fTemp = [cTemp doubleValue]*9/5 + 32;
    
    return [NSNumber numberWithDouble:fTemp];
}


-(NSString*) itemArchivePath{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and the only document directory from that list
    NSString* documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"weatherCondition.data"];
}

-(void)favouriteToTheFirst{
    //change the order of the array by the favourite
    for (int i =0; i<_privateLakeWeathers.count; i++) {
        Weather* weather = [_privateLakeWeathers objectAtIndex:i];
        if([weather.favourite boolValue] == YES && i!= 0){
            NSLog(@"The favourite lake is %@", weather.lakeName);
            _privateLakeWeathers[i] = _privateLakeWeathers[0];
            _privateLakeWeathers[0] = weather;
        }
    }
}

-(BOOL)noFavourite{
    for(int i =0; i< _privateLakeWeathers.count ;i++){
        Weather* temp = [_privateLakeWeathers objectAtIndex:i];
        if([temp.favourite boolValue]){
            return  NO;
        }
    }
    return YES;
}

-(void) checkForOtherFavourite: (NSString*) newlyFavouriteLakeName{
    for (int i =0; i< _privateLakeWeathers.count;i++){
        Weather* tmp = [_privateLakeWeathers objectAtIndex:i];
        if(![tmp.lakeName isEqualToString:newlyFavouriteLakeName]){
            tmp.favourite = [NSNumber numberWithBool:NO];
        }
    }
    [self saveChanges];
}
@end
