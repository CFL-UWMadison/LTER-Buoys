//
//  WebEntranceTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 8/11/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherDataWebEntrance.h"

@interface WebEntranceTest : XCTestCase

@property (nonatomic, strong) WeatherDataWebEntrance* entrance;
@property (nonatomic) BOOL isNetworkOn;
@property (nonatomic, strong) XCTestExpectation* expectation;
@end

@implementation WebEntranceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _entrance = [[WeatherDataWebEntrance alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testGetWebData{
    [_entrance getWeatherData];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError * _Nullable error) {
        NSLog([error description]);
    }];
}


// If you want to test whether the notification will be sent when the network changes with the correct message,
// use this test. After the test runs, you have 10 seconds to turn the network off. If you don't do anything in 10
// seconds, the expectation won't be fullfilled. I can't figure out how to bypass this crash

-(void) testNotificationOnToOff{
    
    XCTAssertTrue(_entrance.isNetworkOn);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"NetworkDidCheckNotification" object:nil];
    
    _expectation = [self expectationWithDescription:@"reachabilityChanged called"];
    
    @try {
        [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
            
        }];
    } @catch (NSException *exception) {
        [_expectation fulfill];
    } @finally {
    }
    
    XCTAssertFalse(_isNetworkOn);
    
}

-(void)reachabilityChanged:(NSNotification*) note{
    
    @try{
        [_expectation fulfill];
    }@catch (NSException* e){
        
    }
    
    
   
    NSDictionary* userInfo = [note userInfo];
    NSLog([userInfo description]);
    
    _isNetworkOn = [(NSNumber*)[userInfo objectForKey:@"isNetworkOn"] boolValue] ;
}

-(void) testConnectionDetectorOn{
    XCTAssertTrue([_entrance isNetworkOn]);
}

// Use this when your network is off
-(void) testConnectionDetectorOff{
    
    XCTAssertFalse([_entrance isNetworkOn]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
