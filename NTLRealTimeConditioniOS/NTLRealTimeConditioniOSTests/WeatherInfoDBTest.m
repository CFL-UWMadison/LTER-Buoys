//
//  WeatherInfoDBTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/3/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherInfoDB.h"
#import "WeatherDBDataEntranceProtocal.h"

@interface WeatherInfoDBTest : XCTestCase <WeatherInfoDBDelegate, WeatherDBDataEntranceProtocal>

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

-(void) testHardCodeData{
    self.db.dataEntrance = self;
    NSArray* testArray = [self.db loadWeathers];
    
    XCTAssertTrue(YES);
}

-(void) getWeatherData{

    [self.db changeLakeData:[self getTestArray]];
}


//!!!! If you want to test the behavior for different data, you should change things
//
-(NSArray*) getTestArray{
    
    NSString* jsonString = @"[{\"airTemp\":9.9,\"lakeId\":\"ME\",\"lakeName\":\"Lake Mendota\",\"phycoMedian\":386.46,\"sampleDate\":\"2016-05-10T19:45:55\",\"secchiEst\":2.24,\"secchiEstTimestamp\":\"2016-05-10T19:00:00\",\"thermoclineDepth\":null,\"waterTemp\":10.0,\"windDir\":107,\"windSpeed\":4.9},{\"airTemp\":11.6,\"lakeId\":\"SP\",\"lakeName\":\"Sparkling Lake\",\"sampleDate\":\"2016-05-10T19:00:00\",\"thermoclineDepth\":5.56,\"waterTemp\":11.42,\"windDir\":106,\"windSpeed\":2.2},{\"airTemp\":17.0,\"lakeId\":\"TR\",\"lakeName\":\"Trout Lake\",\"sampleDate\":\"2015-11-03T15:41:00\",\"thermoclineDepth\":7.51,\"waterTemp\":9.7,\"windDir\":142,\"windSpeed\":2.4}]";
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    return jsonObject;
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

