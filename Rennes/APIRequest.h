//
//  APIRequest.h
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stop.h"


@interface APIRequest : NSObject

@property (nonatomic, strong, readonly) NSArray<Stop *>		*stops;
@property (nonatomic, copy) void (^completionBlock)(NSArray<Stop *> *stops, NSError *error);

@property (nonatomic, assign, getter=isRunning) BOOL		running;

- (instancetype)initWithStops:(NSArray<Stop *> *)stops;
- (void)start;

@end
