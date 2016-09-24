//
//  UserSetting.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 6/5/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "UserSetting.h"

@interface UserSetting ()
@property (nonatomic,strong) NSUserDefaults* userDefault;
@end


@implementation UserSetting

+(UserSetting*) sharedSetting{
    static UserSetting* singleton = nil;
    if (!singleton){
        singleton = [[UserSetting alloc] initPrivate];
        [singleton loadUserSetting];
    }
    return singleton;
}

-(instancetype) initPrivate{
    self = [super init];
    if(self){
        
        //set version, needs to be changed
        self.userDefault = [NSUserDefaults standardUserDefaults];
        
        // Unit setting is represented by the BOOL isBritish in the user setting
        // if the user wants to display in British Unit, then isBritish should be YES
        // if the user wants to display in Metric, then isBritish would be False;
        // The Weather View Controller will use this to configure the display
        [self setUpUnitSetting];
        
        // FirstOpen Setting Option is a
        [self setUpWhetherUserFirstOpen];
        
        // If the user default is just created, this means that he's a new user
        // the update information needs to be poped
        // if firstOpen is true, justUpdated can only be true
        [self checkWhetherUserJustUpdated];
        
        [self setUpUserHomepage];
        
        
    }
    return self;
}


-(void) setUpUnitSetting{
    
    if ([self isKeyInUserDefault:@"testBritish"]){
        self.isBritish = [self.userDefault boolForKey:@"isBritish"];
        
    }
    else {
        [self setIsBritishToDefaultYES];
    }
    
}

-(void) setIsBritishToDefaultYES{
    self.isBritish = YES;
    [self.userDefault setBool:self.isBritish forKey:@"isBritish"];
}

-(BOOL) isKeyInUserDefault:(NSString*) key{
    if (self.userDefault){
        if ([[[self.userDefault dictionaryRepresentation] allKeys] containsObject:key]){
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

-(void) setUpWhetherUserFirstOpen{
    
    NSString* firstOpenKey = @"isFirstOpen";
    if ([self isKeyInUserDefault:firstOpenKey]){
        self.isFirstOpen = [self.userDefault boolForKey:firstOpenKey];
    
    }else{
        // If first open is not in the user setting, then this must be the first time
        // the user uses this app. So self.isFirstOpen will be set to YES. But later this
        // app will be labeled as not first open, so in the user setting, the firstOpen setting
        // will be set to NO as default.
        [self setFirstOpenToDefault:firstOpenKey];
    }
}

-(void) setFirstOpenToDefault: (NSString*) firstOpenKey{
    self.isFirstOpen = YES;
    [self.userDefault setBool:NO forKey:firstOpenKey];
    
}

-(void) checkWhetherUserJustUpdated{
   
    NSString* appVersion = [self getCurrentAppVersion];
    
    if ([self isKeyInUserDefault:@"version"]){
        
        // Read in the version
        self.userSettingVersion = [self.userDefault stringForKey:@"version"];
        
        BOOL userSettingNeedsUpdated = [self compareAppVersionNumberToDecideJustUpdated:appVersion withUserSettingVersionNumber:self.userSettingVersion];
        
        if (userSettingNeedsUpdated){
            [self updateUserSettingWithCurrentAppVersion:appVersion];
        }
    } else{
         self.justUpdated = YES;
        [self updateUserSettingWithCurrentAppVersion:appVersion];

    }
}

-(void) setUpUserHomepage{
    
    // if it returns nil, then the key doesn't exist. Then I need to set up the default value
    self.homepage = (NSString*)[self.userDefault objectForKey:@"homepage"];
    
    if(!self.homepage){
        [self setDefaultHomePage];
    }
}

-(void) setDefaultHomePage{
    self.homepage = @"None";
    [self.userDefault setObject:self.homepage forKey:@"homepage"];
}

-(NSString*) getCurrentAppVersion{
    return [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

-(BOOL) compareAppVersionNumberToDecideJustUpdated:(NSString*) appVersionNumber
                      withUserSettingVersionNumber:(NSString*) userSettingVersion{
    if ([appVersionNumber isEqualToString:userSettingVersion]){
        self.justUpdated = NO;
        return NO;
    }
    self.justUpdated = YES;
    return YES;
}

-(void) updateUserSettingWithCurrentAppVersion:(NSString*) appVersion{
    self.userSettingVersion = appVersion;
    [self.userDefault setObject:appVersion forKey:@"version"];
}


// This will be called to save the user setting
-(void) saveUserSetting{
    [self.userDefault setBool:self.isBritish forKey:@"isBritish"];
    [self.userDefault setObject:self.homepage forKey:@"homepage"];
}

// Load user setting. This will be used to update
-(void) loadUserSetting{
    if(self.userDefault){
        self.isBritish = [self.userDefault boolForKey:@"isBritish"];
        NSLog(@"%d",[self.userDefault boolForKey:@"isBritish"]);
    }
    
    if (self.userDefault){
        self.homepage = (NSString*)[self.userDefault objectForKey:@"homepage"];
    }
}

@end
