//
//  UserSettingTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/5/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserSetting.h"

@interface UserSettingTest : XCTestCase

@property UserSetting* userSetting;

@end

@implementation UserSettingTest

- (void)setUp {
    [super setUp];
    _userSetting = [UserSetting sharedSetting];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void) testIsBritish{
    
    
    BOOL isBritish = _userSetting.isBritish;
    BOOL testBritish = _userSetting.testBritish;
    
    XCTAssertTrue(testBritish);
    
}

-(void) testHomepage{
    
    NSString* homepage = _userSetting.homepage;
    
    XCTAssertEqualObjects(homepage, @"None");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
