//
//  PizzaSpot.m
//  ZaHunter
//
//  Created by Syed Amaanullah on 1/21/15.
//  Copyright (c) 2015 Syed Amaanullah. All rights reserved.
//

#import "PizzaSpot.h"

@implementation PizzaSpot


-(instancetype)initWithMapItem:(MKMapItem *)mapItem {
        self = [super init];
        self.mapItem = mapItem;
        return self;
}


@end
