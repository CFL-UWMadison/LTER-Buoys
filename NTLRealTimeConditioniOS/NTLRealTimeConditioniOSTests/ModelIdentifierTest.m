//
//  ModelIdentifierTest.m
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/2/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IphoneModelSizeIdentifier.h"

@interface ModelIdentifierTest : XCTestCase

@end

@implementation ModelIdentifierTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModelIdentifier {
    // This is an example of a functional test case.
    IphoneModelSizeIdentifier* identifier = [[IphoneModelSizeIdentifier alloc] init];
    NSString* model = [identifier identifyModel:[UIScreen mainScreen]];
    
    XCTAssertEqualObjects(model, @"iPhone 6");
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
