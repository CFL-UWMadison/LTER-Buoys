//
//  WeatherModifierTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 8/18/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "Weather.h"
#import "WeatherInfoDB.h"
#import "WeatherPropertyModifier.h"
#import "WeatherDataWebEntrance.h"

@class WeatherInfoDB;
@interface WeatherModifierTest : XCTestCase <NSURLSessionDataDelegate>

@property (nonatomic, strong) WeatherInfoDB* db;
@property (nonatomic, strong) NSArray* lakes;
@property (nonatomic, strong) WeatherPropertyModifier* modifier;
@property (nonatomic, strong) Weather* emptyWeather;
@property (nonatomic,strong) NSArray* jsonArray;
@property (nonatomic, strong) XCTestExpectation* expectation;
@property (nonatomic, strong) NSDictionary* testJsonObject;
@property (nonatomic, strong) NSString* exampleJsonObject;

@end

@implementation WeatherModifierTest

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.jsonArray = jsonArray;
    self.testJsonObject = (NSDictionary*)[jsonArray objectAtIndex:0];
    
    NSLog( [self.jsonArray description] );
    XCTAssertTrue(true);
    XCTAssertNotNil(self.emptyWeather);
    XCTAssertNotNil(self.jsonArray);
    [self.expectation fulfill];
    
}


-(NSDictionary*) getTestJson{
    NSString* jsonString = @"{\"airTemp\":9.9,\"lakeId\":\"ME\",\"lakeName\":\"Lake Mendota\",\"phycoMedian\":386.46,\"sampleDate\":\"2016-05-10T19:45:55\",\"secchiEst\":2.24,\"secchiEstTimestamp\":\"2016-05-10T19:00:00\",\"thermoclineDepth\":null,\"waterTemp\":10.0,\"windDir\":107,\"windSpeed\":4.9}";
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary* jsonObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    
    return jsonObject;
}

- (void)setUp {
    [super setUp];
    self.db = [WeatherInfoDB sharedDB];
    self.modifier = [[WeatherPropertyModifier alloc] init];
    self.emptyWeather = [self.db createEmptyNewWeather];
    self.testJsonObject = [self getTestJson];
    
    //self.expectation = [self expectationWithDescription:@"Test get data"];
    
    //WeatherDataWebEntrance* webEntrance = [[WeatherDataWebEntrance alloc] init];
    //webEntrance.delegate = self;
    //[webEntrance getDataFromWeb];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModifer {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    self.emptyWeather.lakeId = [self.testJsonObject objectForKey:@"lakeId"];
    self.emptyWeather.lakeName = [self.testJsonObject objectForKey:@"lakeName"];
    
    _emptyWeather = [self.modifier modificationFromJSONSource:_testJsonObject ToTargetWeather:_emptyWeather];
    XCTAssertEqual([_emptyWeather.airTemp doubleValue], 9.9);
    XCTAssertEqual([_emptyWeather.waterTemp doubleValue], 10.0);
    XCTAssertEqual([_emptyWeather.secchiEst doubleValue], 2.24);
    XCTAssertEqual([_emptyWeather.thermoclineDepth doubleValue], 999);
    //XCTAssertLessThan([_emptyWeather.phychoMedian doubleValue], 629);
    XCTAssertNotNil(_emptyWeather);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
