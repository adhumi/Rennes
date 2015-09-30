//
//  APIRequest.m
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "APIRequest.h"
#import "APIURLMaker.h"
#import "AFNetworking.h"
#import "StopsHolder.h"
#import "XMLDictionary.h"


@interface APIRequest ()

@property (nonatomic, strong, readonly) NSURL			*requestURL;
@property (nonatomic, strong) AFHTTPRequestOperation	*operation;

@end



@implementation APIRequest

- (void)start {	
	NSURLRequest *request = [NSURLRequest requestWithURL:self.requestURL];
	
	self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	self.operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	__weak __typeof(self)weakSelf = self;
	[self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSError *error;
		NSMutableArray *stopsWithDepartures = [NSMutableArray array];
		
		NSDictionary *dictionary = [NSDictionary dictionaryWithXMLParser:responseObject];
		
		id stopsDepartures = [dictionary valueForKeyPath:@"answer.data.stopline"];
		
		if ([stopsDepartures isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dic in stopsDepartures) {
				StopLine *stopline = [[StopLine alloc] initWithDictionary:dic];
				Stop *stop = [[StopsHolder instance] stopForIdentifier:stopline.stopId];
				
				if (![stop.stopLines containsObject:stopline]) {
					[stop.stopLines addObject:stopline];
				}
				
				if (![stopsWithDepartures containsObject:stop]) {
					[stopsWithDepartures addObject:stop];
				}
			}
		} else if ([stopsDepartures isKindOfClass:[NSDictionary class]]) {
			StopLine *stopline = [[StopLine alloc] initWithDictionary:stopsDepartures];
			Stop *stop = [[StopsHolder instance] stopForIdentifier:stopline.stopId];
			
			if (![stop.stopLines containsObject:stopline]) {
				[stop.stopLines addObject:stopline];
			}
			
			if (![stopsWithDepartures containsObject:stop]) {
				[stopsWithDepartures addObject:stop];
			}
		}
		
		if (stopsWithDepartures.count == 0) {
			error = [[NSError alloc] initWithDomain:@"fr.adhumi.Rennes.request" code:404 userInfo:@{NSLocalizedDescriptionKey: @"Pas de passage de bus à proximité prochainement."}];
		}
		
		if (weakSelf.completionBlock) {
			weakSelf.completionBlock([NSArray arrayWithArray:stopsWithDepartures], error);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
		
		if (weakSelf.completionBlock) {
			weakSelf.completionBlock(nil, error);
		}
	}];
	
	[[NSOperationQueue mainQueue] addOperation:self.operation];
}

- (NSURL *)requestURL {
	return [APIURLMaker nextDeparturesForStops:self.stops];
}

- (BOOL)isRunning {
	return self.operation.isExecuting;
}

@end
