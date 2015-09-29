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

@property (nonatomic, strong) NSArray<Stop *>			*stops;
@property (nonatomic, strong, readonly) NSURL			*requestURL;
@property (nonatomic, strong) AFHTTPRequestOperation	*operation;

@end



@implementation APIRequest

- (instancetype)initWithStops:(NSArray<Stop *> *)stops {
	self = [self init];
	if (self) {
		self.stops = stops;
	}
	return self;
}

- (void)start {	
	NSURLRequest *request = [NSURLRequest requestWithURL:self.requestURL];
	
	self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	self.operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	__weak __typeof(self)weakSelf = self;
	[self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *nearbyStops = [NSMutableArray array];
		
		NSDictionary *dictionary = [NSDictionary dictionaryWithXMLParser:responseObject];
		
		id stopsDepartures = [dictionary valueForKeyPath:@"answer.data.stopline"];
		
		if ([stopsDepartures isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dic in stopsDepartures) {
				StopLine *stopline = [[StopLine alloc] initWithDictionary:dic];
				Stop *stop = [[StopsHolder instance] stopForIdentifier:stopline.stopId];
				
				[stop.stopLines addObject:stopline];
				[nearbyStops addObject:stop];
			}
		}
		if ([stopsDepartures isKindOfClass:[NSDictionary class]]) {
				StopLine *stopline = [[StopLine alloc] initWithDictionary:stopsDepartures];
				Stop *stop = [[StopsHolder instance] stopForIdentifier:stopline.stopId];
				
				[stop.stopLines addObject:stopline];
				[nearbyStops addObject:stop];
		}
		
		
		if (weakSelf.completionBlock) {
			weakSelf.completionBlock([NSArray arrayWithArray:nearbyStops], nil);
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
