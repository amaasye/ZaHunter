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
@property CLLocationManager *locationManager;
@property MKMapItem *mapItem;


@end

@implementation PizzaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.textView.text = @"Finding pizza joints...";

}

#pragma mark - Location Manager
//in case of error
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}
//retrieves the directions
- (IBAction)startGettingPizza:(UIButton *)sender {

}

//what happens after the location is updated:
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 100 && location.verticalAccuracy < 100) {
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
    //sets the search region as 20 square kilometers
    request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000);

    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //puts the search response map items into an array called pizzaPlaces
        self.pizzaPlaces = response.mapItems;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View

//sets the number of rows in the table view to be the number of pizza places that are generated thru the search
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pizzaPlaces.count;
}

//populates the table view with the relevent data
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];

    //alloc our custom class and initialize it with a mapItem
    PizzaSpot *pizzaSpot = [[PizzaSpot alloc]initWithMapItem:self.mapItem];
    pizzaSpot = [self.pizzaPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = pizzaSpot.name;

   CLLocationDistance distance = [pizzaSpot.mapItem.placemark.location distanceFromLocation:self.locationManager.location];

    //convert the double (meters) to a string
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:distance];
    NSString *distanceString = [myDoubleNumber stringValue];

    //assign the detail label text of our cell to that string
    cell.detailTextLabel.text = distanceString;
    
    return cell;
}







@end
