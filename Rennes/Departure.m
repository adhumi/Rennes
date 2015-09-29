//
//  Departure.m
//  Rennes
//
//  Created by Adrien Humilière on 29/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "Departure.h"

@implementation Departure

- (instancetype)initWithDictionary:(NSDictionary *)dictionary stopId:(NSString *)stopId {
	self = [super init];
	if (self) {
		self.stopId = stopId;
		
		self.accurate = [dictionary[@"_accurate"] integerValue];
		self.headsign = dictionary[@"_headsign"];
		self.vehicleId = dictionary[@"_vehicle"];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		self.expectedTime = [dateFormatter dateFromString:dictionary[@"_expected"]];
		self.arrivalTime = [dateFormatter dateFromString:dictionary[@"__text"]];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[Departure class]]) {
		return NO;
	}
	
	Departure *castedObject = (Departure *)object;
	
	return [self.stopId isEqualToString:castedObject.stopId] && [self.vehicleId isEqualToString:castedObject.vehicleId] && [self.expectedTime isEqual:castedObject.expectedTime];
}

@end
