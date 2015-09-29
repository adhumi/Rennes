//
//  Stop.m
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "Stop.h"

@implementation Stop

- (instancetype)initWithCSVLine:(NSArray<NSString *> *)line {
	self = [self init];
	if (self) {
		if (line.count < 11) { return nil; }
		
		self.stopLines = [NSMutableArray array];
		
		self.stopId = [line[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.stopCode = [line[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.stopName = [line[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.stopDescription = [line[3] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		
		CLLocationDegrees latitude = [line[4] stringByReplacingOccurrencesOfString:@"\"" withString:@""].doubleValue;
		CLLocationDegrees longitude = [line[5] stringByReplacingOccurrencesOfString:@"\"" withString:@""].doubleValue;
		self.location = CLLocationCoordinate2DMake(latitude, longitude);
		
		self.zoneId = [line[6] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.locationType = [line[7] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.stopURL = [NSURL URLWithString:[line[8] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
		self.parentStation = [line[9] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.stopTimezone = [line[10] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		self.wheelchairBoarding = [line[11] stringByReplacingOccurrencesOfString:@"\"" withString:@""].integerValue == 1;
	}
	return self;
}

@end
