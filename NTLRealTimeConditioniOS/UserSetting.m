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
        @try {
            self.isBritish = [self.userDefault boolForKey:@"isBritish"];
            
        } @catch (NSException *exception) {
            self.isBritish = YES;
        }
        
        
        // This setting is used to determine whether the update message needs to be displayed
        @try {
            self.isFirstOpen = [self.userDefault boolForKey:@"isFirstOpen"];
        } @catch (NSException *exception) {
            self.isFirstOpen = YES;
            [self.userDefault setBool:NO forKey:@"isFirstOpen"];
        }
        
        // If the user default is just created, this means that he's a new user
        // the update information needs to be poped
        // if firstOpen is true, justUpdated can only be true
        // if justUpdated is true, firstOpen can be false
        
        @try{
            NSString* currentVersion = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            
            self.version = (NSString*) [self.userDefault stringForKey:@"version"];
            if ([currentVersion isEqualToString:self.version]){
                self.justUpdated = NO;
            } else{
                self.justUpdated = YES;
                self.version = currentVersion;
                [self.userDefault setObject:currentVersion forKey:@"version"];
                
            }
        } @catch (NSException *exception){
            self.justUpdated = YES;
        }
    }
    return self;
}

-(void) saveUserSetting{
    [self.userDefault setBool:self.isBritish forKey:@"isBritish"];
}

-(void) loadUserSetting{
    if(self.userDefault){
        self.isBritish = [self.userDefault boolForKey:@"isBritish"];
        NSLog(@"%d",[self.userDefault boolForKey:@"isBritish"]);
    }
}

@end
