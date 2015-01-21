//
//  GetPizzas.h
//  ZaHunter
//
//  Created by Syed Amaanullah on 1/21/15.
//  Copyright (c) 2015 Syed Amaanullah. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@protocol PizzaGrabberDelegate <NSObject>
-(void)pizzaGrabberDidFinishWithPizzaSpots:(NSArray*)pizzaPlaces;


@end

@interface PizzaGrabber : NSObject
@property id<PizzaGrabberDelegate> delegate;

@end
