//
//  Stop.h
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import "StopLine.h"



@interface Stop : NSObject

@property (nonatomic, strong) NSString						*stopId;
@property (nonatomic, strong) NSString						*stopCode;
@property (nonatomic, strong) NSString						*stopName;
@property (nonatomic, strong) NSString						*stopDescription;
@property (nonatomic, assign) CLLocationCoordinate2D		location;
@property (nonatomic, strong) NSString						*zoneId;
@property (nonatomic, strong) NSURL							*stopURL;
@property (nonatomic, strong) NSString						*locationType;
@property (nonatomic, strong) NSString						*parentStation;
@property (nonatomic, strong) NSString						*stopTimezone;
@property (nonatomic, assign) BOOL							wheelchairBoarding;

@property (nonatomic, strong) NSMutableArray<StopLine *>	*stopLines;

- (instancetype)initWithCSVLine:(NSArray<NSString *> *)line;

@end
