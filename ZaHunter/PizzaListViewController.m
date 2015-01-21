//
//  ViewController.m
//  ZaHunter
//
//  Created by Syed Amaanullah on 1/21/15.
//  Copyright (c) 2015 Syed Amaanullah. All rights reserved.
//

#import "PizzaListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PizzaSpot.h"

@interface PizzaListViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSArray *pizzaPlaces;
@property PizzaSpot *pizzaSpot;
@property CLLocationManager *locationManager;


@end

@implementation PizzaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];

}

#pragma mark - Location Manager
//in case of error
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}
//retrieves the most recent location
- (IBAction)startGettingPizza:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
    self.textView.text = @"Finding pizza joints...";

}
//what happens after the location is updated:
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
            self.textView.text = @"";
            [self.locationManager stopUpdatingLocation];
            [self findPizzaNear:location];
            break;
        }
    }
}

//the method used to search for Pizza places near the user
-(void)findPizzaNear:(CLLocation *)location {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"Pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));

    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //puts the search response map items into an array called pizzaPlaces
        self.pizzaPlaces = response.mapItems;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View

//sets the number of rows in the table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pizzaPlaces.count;
}

//populates the table view with the relevent data
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    //sets an instance of the custom object for each item in the array of pizza places
    self.pizzaSpot = [self.pizzaPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = self.pizzaSpot.name;
    cell.detailTextLabel.text = self.pizzaSpot.placemark.title;
    return cell;
}







@end
