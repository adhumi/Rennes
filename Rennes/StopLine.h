//
//  StopLine.h
//  Rennes
//
//  Created by Adrien Humilière on 29/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import Foundation;

#import "Departure.h"



@interface StopLine : NSObject

@property (nonatomic, strong) NSMutableArray<Departure *>	*departures;

@property (nonatomic, assign) NSInteger				direction;
@property (nonatomic, strong) NSString				*route;
@property (nonatomic, strong) NSString				*stopId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
