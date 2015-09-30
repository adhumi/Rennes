//
//  APIURLMaker.h
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stop.h"



@interface APIURLMaker : NSObject

+ (NSURL * _Nullable)nextDeparturesForStops:(NSArray<Stop *> * _Nonnull)stopIds;

@end
