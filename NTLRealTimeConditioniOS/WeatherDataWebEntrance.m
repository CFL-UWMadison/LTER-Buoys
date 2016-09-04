//
//  WeatherDataWebEntrance.m
//  NTLRealTimeConditioniOS
//
//  Get data from the web, and then send it to its delegate, weather info database
//  If no network connection is on, send a notification to the view controller
//  the status of the network.
//
//  Created by Junjie on 8/2/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "WeatherDataWebEntrance.h"

//Reachability will send a "kNetworkReachabilityChangedNotification", one way is to use another notification
//to be a wrapper for the rest of the system, to facilitate the code. The other way is to let other component to
//listen to that. I prefer the first one, because even though the implementation of the reachability would be
//changed (probably use AFNetwork), the overall logic will still be integrate. Only this class need to worry about
//Reachability.

#import "Reachability.h"

@interface WeatherDataWebEntrance ()

@property (nonatomic) NSString* dataServiceURL;
@property (nonatomic, strong) Reachability* internetReachability;


@end

@implementation WeatherDataWebEntrance

- (instancetype) init{
    self = [self initWithDatabase:nil];
    return self;
}

-(instancetype) initWithDatabase: (WeatherInfoDB*) db{
    self = [super init];
    if (self) {
        _isNetworkOn = YES;
        self.delegate = db;
        [self startDetectingNetworkStatus];
    }
    return self;
}

-(void) startDetectingNetworkStatus{
    
    //create the reachability from the Reachability
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    //ask the class to send notification as long as it notices that reachability is changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //send notifcation to the other class
    [self sendNetworkDidCheckNotification:_internetReachability];
    
}

-(void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self sendNetworkDidCheckNotification:curReach];
}


-(NSString*) getDataServiceURL{
    return @"http://thalassa.limnology.wisc.edu:8080/LakeConditionService/webapi/lakeConditions";
}

// The data will be transferred to the delegate (WeatherDB) for further process
-(void) getDataFromWeb{
    
    NSURL* url = [NSURL URLWithString:[self getDataServiceURL]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self.delegate delegateQueue:nil];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionTask* getLakeInfo = [session dataTaskWithRequest:request];
    [getLakeInfo resume];
}


// This method interprets the network status and sends the notification that will tell the rest of the system whether the network is on or not.
-(void) sendNetworkDidCheckNotification:(Reachability*) reachability {
    
    _isNetworkOn = [self decideWhetherNetworkIsOn:reachability];
    
    // add network info to userInfo
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSNumber numberWithBool:_isNetworkOn] forKey:@"isNetworkOn"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkDidCheckNotification" object:self userInfo:userInfo];
    
}

-(BOOL)decideWhetherNetworkIsOn:(Reachability*) reachability{
    
    NetworkStatus netStatus =  [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:        {
            return NO;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
        }
            
        case ReachableViaWWAN:        {
            break;
        }
        case ReachableViaWiFi:        {
            break;
        }
            
    }
    
    
    // I still have some doubt on connection required.
    if(connectionRequired){
        return NO;
    }
    
    return YES;
}

@end
