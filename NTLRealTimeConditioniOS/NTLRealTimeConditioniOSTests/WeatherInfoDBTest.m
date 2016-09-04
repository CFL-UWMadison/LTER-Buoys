//
//  WeatherInfoDBTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/3/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherInfoDB.h"

@interface WeatherInfoDBTest : XCTestCase <WeatherInfoDBDelegate>

@property (nonatomic, strong) WeatherInfoDB* db;
@property (nonatomic, strong) XCTestExpectation* expectation;

@end

@implementation WeatherInfoDBTest

- (void)setUp {
    [super setUp];
    self.db = [WeatherInfoDB sharedDB];
    self.db.delegate = self;
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"DataNeedsUpdateNotification" object:self];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDelegate {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    self.expectation = [self expectationWithDescription:@"HELLO"];
    //[self.db loadWeathers];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

-(void) testAutoUpdateNotification{
    self.expectation = [self expectationWithDescription:@"HELLO"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataNeedsUpdateNotification" object:self];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void) receive:(NSNotification*) notification{
    NSLog(@"I receive the notification");
    [self.expectation fulfill];
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) weatherInfoDBAfterDataUpdated:(WeatherInfoDB *)db{
    [self.expectation fulfill];
    NSLog(@"The delegate method has been called");
    XCTAssertTrue(YES);
    
}
@end

