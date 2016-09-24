//
//  UserSetting.h
//
//  Model for the Menu View Controller
//
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 6/5/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSetting : NSObject

@property (nonatomic) BOOL isBritish;
@property (nonatomic) BOOL isFirstOpen;
@property (nonatomic, strong) NSString* userSettingVersion;
@property (nonatomic) BOOL justUpdated;
@property (nonatomic, strong) NSString* homepage;
@property (nonatomic) BOOL testBritish;

+(UserSetting*) sharedSetting;
-(void) saveUserSetting;
-(void) loadUserSetting;

@end
