//
//  IJMapViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMapViewController.h"
#import <MapKit/MapKit.h>
#import "IJLocation.h"

@interface IJMapViewController () <UISearchBarDelegate, MKMapViewDelegate>
@property(nonatomic) MKMapView *mapView;
@property(nonatomic) NSMutableArray *locations;
@end

@implementation IJMapViewController

- (instancetype)initWithLocations:(NSArray *)locations {
  self = [super init];
  if (self) {
    self.locations = [locations mutableCopy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.title || [self.title isEqualToString:@""])
    self.title = @"Map";
  self.edgesForExtendedLayout = UIRectEdgeNone;
  UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
  searchBar.barTintColor = kIJumboBlue;
  searchBar.tintColor = [UIColor whiteColor];
  searchBar.delegate = self;
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, searchBar.maxY, self.view.width, self.view.height - searchBar.height)];
  self.mapView.delegate = self;
  self.mapView.zoomEnabled = YES;
  // TODO(amadou): Wait until they click on the current location button.
  // Once that happens set a default that tracks this. And show if they have agreed.
  if (YES) // Use default here.
    self.mapView.showsUserLocation = YES;
  [self.view addSubview:searchBar];
  [self.view addSubview:self.mapView];
  if (self.locations) {
    [self.mapView showAnnotations:self.locations animated:YES];
  }
  [self.mapView setRegion:[IJMapViewController tuftsRegion] animated:NO];
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

// Zooms the map view into the Tufts campus.
+ (MKCoordinateRegion)tuftsRegion {
  CLLocationCoordinate2D center;
  center.latitude = 42.405524;
  center.longitude = -71.119802;
  MKCoordinateSpan span;
  span.latitudeDelta  = 0.017;
  span.longitudeDelta = 0.017;
  MKCoordinateRegion region;
  region.center = center;
  region.span = span;
  return region;
}

- (void)removeLocationsFromMap {
  [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)addLocationToMap:(IJLocation *)location {
  // TODO(amadou): Should drop the pin and zoom into it.
  [self.mapView addAnnotation:location];  
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  static NSString * const identifier = @"IJMapVCAnnotationIdentifier";
  if ([annotation isKindOfClass:[IJLocation class]]) {
    MKAnnotationView *annotationView =
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
      annotationView =
          [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = YES;
    } else {
      annotationView.annotation = annotation;
    }
  }
  return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  NSLog(@"Did click callout - do something.");
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  searchBar.text = @"";
  [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
  [self.delegate mapViewController:self didSearchForText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (searchText.length == 0 && searchBar.showsCancelButton) {
    [searchBar setShowsCancelButton:NO animated:YES];
  } else if (searchText.length > 0 && !searchBar.showsCancelButton) {
    [searchBar setShowsCancelButton:YES animated:YES];
  }
}

@end
