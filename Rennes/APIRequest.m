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
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"XML: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[[NSOperationQueue mainQueue] addOperation:operation];
}

- (NSURL *)requestURL {
	return [APIURLMaker nextDeparturesForStops:self.stops];
}

@end
