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
@property(nonatomic) NSArray *locations;
@end

@implementation IJMapViewController

- (instancetype)initWithLocations:(NSArray *)locations {
  self = [super init];
  if (self) {
    self.locations = locations;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
  searchBar.barTintColor = kIJumboBlue;
  searchBar.tintColor = [UIColor whiteColor];
  searchBar.delegate = self;
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, searchBar.maxY, self.view.width, self.view.height - searchBar.height)];
  self.mapView.delegate = self;
  [self.view addSubview:searchBar];
  [self.view addSubview:self.mapView];
  if (self.locations) {
    [self addLocationsToMap:self.locations];
  }
}

- (void)removeLocationsFromMap {
  [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)addLocationsToMap:(NSArray *)locations {
  for (IJLocation *location in locations) {
    [self.mapView addAnnotation:location];
  }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  static NSString * const identifier = @"AnnotationIdentifier";
  if ([annotation isKindOfClass:[IJLocation class]]) {
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
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
