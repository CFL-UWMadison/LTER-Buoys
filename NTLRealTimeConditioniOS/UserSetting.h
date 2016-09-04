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
@property (nonatomic) NSString* version;
@property (nonatomic) BOOL justUpdated;


+(UserSetting*) sharedSetting;
-(void) saveUserSetting;
-(void) loadUserSetting;

@end
