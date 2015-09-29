//
//  APIURLMaker.m
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "APIURLMaker.h"



@implementation APIURLMaker

static NSString *BASE_URL = @"http://data.keolis-rennes.com/xml";
static NSString *API_KEY = @"UJLQKY6MHQVART6";

+ (NSURL *)nextDeparturesForStops:(NSArray<Stop *> *)stops {
	return [NSURL URLWithString:@"http://192.168.0.21/test.xml"];
	
	
	
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/?cmd=getbusnextdepartures&version=2.2&key=%@&param[mode]=stop", BASE_URL, API_KEY];
    
    for (Stop *stop in stops) {
        [urlString appendFormat:@"&param[stop][]=%@", stop.stopId];
    }
    
    return [NSURL URLWithString:urlString];
}

@end
