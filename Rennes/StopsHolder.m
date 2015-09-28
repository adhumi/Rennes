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
	MKMapPoint originPoint = MKMapPointForCoordinate(coordinates);
	
	NSArray *sortedArray;
	sortedArray = [self.stops sortedArrayUsingComparator:^NSComparisonResult(Stop *a, Stop *b) {
		MKMapPoint pointA = MKMapPointForCoordinate(a.location);
		MKMapPoint pointB = MKMapPointForCoordinate(b.location);
		
		CLLocationDistance distanceA = MKMetersBetweenMapPoints(originPoint, pointA);
		CLLocationDistance distanceB = MKMetersBetweenMapPoints(originPoint, pointB);
		
		if (distanceA < distanceB) {
			return NSOrderedAscending;
		} else if (distanceA == distanceB) {
			return NSOrderedSame;
		} else {
			return NSOrderedDescending;
		}
	}];
	
	return [sortedArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)]];
}

@end
