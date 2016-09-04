//
//  IphoneModelIdentifier.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/2/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "IphoneModelSizeIdentifier.h"

@implementation IphoneModelSizeIdentifier

-(instancetype) init{
    self = [super init];
    if (self){
        _iPhone5Height = 568;
        _iPhone4Height = 480;
        _iPhone6Height = 667;
        _iPhone6PlusHeight = 736;
    }
    
    return self;
}

-(NSString*) identifyModel:(UIScreen*) mainScreen {

    if ([mainScreen bounds].size.height == _iPhone5Height){
        return @"iPhone 5";
    
    } else if([mainScreen bounds].size.height == _iPhone4Height) {
        return @"iPhone 4";
    } else if([mainScreen bounds].size.height == _iPhone6PlusHeight) {
        return @"iPhone 6Plus";
    } else if ([mainScreen bounds].size.height == _iPhone6Height){
        return @"iPhone 6";
    }
    
    @throw [NSException exceptionWithName:@"NoModelException" reason:@"This screen can't be identified" userInfo:nil];

}

@end
