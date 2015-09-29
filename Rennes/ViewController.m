//
//  ViewController.m
//  Rennes
//
//  Created by Adrien Humilière on 28/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import "ViewController.h"
#import "APIRequest.h"
#import "StopsHolder.h"



@interface ViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CLLocationManager		*locationManager;

@property (weak, nonatomic) IBOutlet MKMapView		*mapView;
@property (weak, nonatomic) IBOutlet UITableView	*tableView;

@property (nonatomic, strong) NSArray<Stop *>		*stops;

@property (nonatomic, strong) APIRequest			*request;

@end



@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager requestLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int nbDepartures = 0;
	for (StopLine *stopLine in self.stops[section].stopLines) {
		nbDepartures += stopLine.departures.count;
	}
	
	return nbDepartures;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartureCell" forIndexPath:indexPath];
	
	Departure *departure = [self departureForIndexPath:indexPath];
	NSTimeInterval remainingTime = [departure.expectedTime timeIntervalSinceDate:[NSDate date]];
	
	cell.textLabel.text = departure.headsign;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d min", (int)remainingTime / 60];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"%@, %@", self.stops[section].stopName, self.stops[section].stopDescription];
}

- (Departure *)departureForIndexPath:(NSIndexPath *)indexPath {
	Stop *stop = self.stops[indexPath.section];
	
	int i = 0;
	for (StopLine *stopLine in stop.stopLines) {
//		if (i + stopLine.departures.count < indexPath.row) {
//			return stopLine.departures[indexPath.row - i];
//		}
//		
//		i += stopLine.departures.count;
		for (Departure *departure in stopLine.departures) {
			if (i == indexPath.row) {
				return departure;
			}
			
			++i;
		}
	}
	
	return nil;
}



#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = locations.lastObject;
	
	[self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
	
	if (self.request && self.request.isRunning) {
		return;
	}
	
	NSArray<Stop *> *stops = [[StopsHolder instance] closestStopsForCoordinates:location.coordinate];
	
	__weak __typeof(self)weakSelf = self;
	self.request = [[APIRequest alloc] initWithStops:stops];
	self.request.completionBlock = ^void(NSArray<Stop *> *stops, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			weakSelf.stops = stops;
			[weakSelf.tableView reloadData];
			
			[weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
			
			for (Stop *stop in stops) {
				MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
				[annotation setCoordinate:stop.location];
				[annotation setTitle:[NSString stringWithFormat:@"%@, %@", stop.stopName, stop.stopDescription]];
				[weakSelf.mapView addAnnotation:annotation];
			}
		});
	};
	[self.request start];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_2) {
	[self.locationManager requestLocation];
}

@end
