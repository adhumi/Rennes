//
//  StopsHolder.m
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import MapKit;

#import "StopsHolder.h"
#import "CHCSVParser.h"



@interface StopsHolder ()

@end



@implementation StopsHolder

+ (instancetype)instance {
	static StopsHolder *instance;
	@synchronized(self) {
		static dispatch_once_t pred;
		dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
	}
	return instance;
}

- (instancetype)init {
	self = [super init];
	if (self) {

	}
	return self;
}

- (void)loadData {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"csv"];
	NSURL *urlScheme = [NSURL URLWithString:@"file://"];
	NSURL *csvURL = [NSURL URLWithString:path relativeToURL:urlScheme];
	
	NSArray *csvContent = [NSArray arrayWithContentsOfDelimitedURL:csvURL options:CHCSVParserOptionsRecognizesBackslashesAsEscapes delimiter:','];
	
	NSMutableArray *results = [NSMutableArray array];
	
	for (NSArray *array in csvContent) {
		if (![array isKindOfClass:[NSArray class]]) { return; }
		
		Stop *stop = [[Stop alloc] initWithCSVLine:array];
		if (stop) {
			[results addObject:stop];
		}
	}
	
	self.stops = [NSArray arrayWithArray:results];
}

- (NSArray<Stop *> *)closestStopsForCoordinates:(CLLocationCoordinate2D)coordinates {
//	MKMapPoint point1 = MKMapPointForCoordinate(coordinates);
//	
//	NSMutableArray<Stop *> * closestStops = [NSMutableArray array];
//	
//	for (Stop *stop in self.stops) {
//		MKMapPoint point2 = MKMapPointForCoordinate(stop.location);
//		CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
//
//		if (distance < smallestDistance) {
//			distance = smallestDistance;
//			closestLocation = location;
//		}
//	}
	return nil;
}

@end
