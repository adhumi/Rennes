//
//  StopLine.m
//  Rennes
//
//  Created by Adrien Humilière on 29/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "StopLine.h"

@implementation StopLine

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.departures = [NSMutableArray array];
		
		self.direction = [dictionary[@"direction"] integerValue];
		self.route = dictionary[@"route"];
		self.stopId = dictionary[@"stop"];
		
		id departures = [dictionary valueForKeyPath:@"departures.departure"];
		
		if ([departures isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dic in departures) {
				Departure *departure = [[Departure alloc] initWithDictionary:dic stopId:self.stopId];
				[self.departures addObject:departure];
			}
		}
		
		if ([departures isKindOfClass:[NSDictionary class]]) {
			Departure *departure = [[Departure alloc] initWithDictionary:departures stopId:self.stopId];
			[self.departures addObject:departure];
		}
		
		
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[StopLine class]]) {
		return NO;
	}
	
	StopLine *castedObject = (StopLine *)object;
	
	return [self.stopId isEqualToString:castedObject.stopId] && [self.route isEqualToString:castedObject.route];
}

@end
