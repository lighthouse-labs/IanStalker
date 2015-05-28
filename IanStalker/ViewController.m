//
//  ViewController.m
//  IanStalker
//
//  Created by Ian MacKinnon on 2015-05-28.
//  Copyright (c) 2015 Ian MacKinnon. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    bool initialLocationSet;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    initialLocationSet = false;
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    _locationManager.delegate = self;
    
    //This is bad as the location manager might not have a location yet
    //CLLocation *initalLocaiton = [_locationManager location];
    //[self.mapView setCenterCoordinate:initalLocaiton.coordinate];
    
    MKPointAnnotation *marker=[[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D iansApartmentLocation;
    iansApartmentLocation.latitude = 49.268950;
    iansApartmentLocation.longitude = -123.153739;
    marker.coordinate = iansApartmentLocation;
    marker.title = @"Ian's Apartment";
    
    [self.mapView addAnnotation:marker];
    
    self.mapView.showsUserLocation = true;
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Got error %@", [error localizedDescription]);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];
    
    if (!initialLocationSet){
        
        MKCoordinateRegion startingRegion;
        CLLocationCoordinate2D loc = location.coordinate;
        startingRegion.center = loc;
        startingRegion.span.latitudeDelta = 0.02;
        startingRegion.span.longitudeDelta = 0.02;
        [self.mapView setRegion:startingRegion];
        
        //This is still valid but won't zoom in
        //[self.mapView setCenterCoordinate:location.coordinate];
        initialLocationSet = true;
    }
    
    NSLog(@"Got location %@", location);
}

#pragma MKMapViewDelegate

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //Here you would want to re-request startupdatinglocation
    // if given authorization
    //[_locationManager startUpdatingLocation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (annotation == self.mapView.userLocation){
        return nil; //default to blue dot
    }
    
    static NSString* annotationIdentifier = @"iansApartment";
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        // if an existing pin view was not available, create one
        pinView = [[MKPinAnnotationView alloc]
                   initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    pinView.calloutOffset = CGPointMake(-15, 0);
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Click" message:@"You Done Clicked" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}


@end
