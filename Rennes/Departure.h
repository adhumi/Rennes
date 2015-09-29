//
//  Departure.h
//  Rennes
//
//  Created by Adrien Humilière on 29/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import Foundation;



@interface Departure : NSObject

@property (nonatomic, assign) NSInteger		accurate;
@property (nonatomic, assign) NSInteger		line;
@property (nonatomic, strong) NSDate		*expectedTime;
@property (nonatomic, strong) NSDate		*arrivalTime;
@property (nonatomic, strong) NSString		*headsign;
@property (nonatomic, strong) NSString		*vehicleId;

@property (nonatomic, strong) NSString		*stopId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary stopId:(NSString *)stopId line:(NSInteger)line;

@end
