//
//  RennesTests.m
//  RennesTests
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import XCTest;

#import "APIRequest.h"
#import "APIURLMaker.h"
#import "AFNetworking.h"
#import "StopsHolder.h"
#import "XMLDictionary.h"
#import "UIImage+BusLineLogo.h"


@interface RennesTests : XCTestCase

@property (nonatomic, strong) APIRequest			*request;

@end



@implementation RennesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckRequest {
	__block NSArray *initialStops = @[
									  [[StopsHolder instance] stopForIdentifier:@"1010"],
									  [[StopsHolder instance] stopForIdentifier:@"1011"],
									  [[StopsHolder instance] stopForIdentifier:@"1012"],
									  [[StopsHolder instance] stopForIdentifier:@"1014"],
									  [[StopsHolder instance] stopForIdentifier:@"1015"],
									  ];
	
	self.request = [[APIRequest alloc] initWithStops:initialStops];
	self.request.completionBlock = ^void(NSArray<Stop *> *stops, NSError *error) {
		XCTAssertEqual(stops.count, initialStops.count);
	};
	[self.request start];
}

- (void)testCheckLineImage {
    [self measureBlock:^{
		UIImage *image = [UIImage busLogoForNumber:42];
		XCTAssertNotNil(image);
    }];
}

@end
