//
//  StopsHolder.h
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import Foundation;

#import "Stop.h"



@interface StopsHolder : NSObject

@property (nonatomic, strong) NSArray<Stop *>	*stops;

+ (instancetype)instance;

- (void)loadData;
- (NSArray<Stop *> *)closestStopsForCoordinates:(CLLocationCoordinate2D)coordinates;
- (Stop *)stopForIdentifier:(NSString *)stopId;

@end
