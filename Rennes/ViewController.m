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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Sell %ld", (long)indexPath.row];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"Section %ld", (long)section];
}



#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = locations.lastObject;
	
	[self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
	NSArray<Stop *> *stops = [[StopsHolder instance] closestStopsForCoordinates:location.coordinate];
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_2) {
	[self.locationManager requestLocation];
}

@end
