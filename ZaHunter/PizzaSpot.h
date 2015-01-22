//
//  PizzaSpot.h
//  ZaHunter
//
//  Created by Syed Amaanullah on 1/21/15.
//  Copyright (c) 2015 Syed Amaanullah. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PizzaSpot : NSObject
@property NSString *name;
@property double distance;
@property MKMapItem *mapItem;
@property CLLocation *location;

-(instancetype)initWithMapItem:(MKMapItem *)mapItem;

@end
