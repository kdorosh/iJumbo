//
//  IJMapViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMapViewController.h"
#import <MapKit/MapKit.h>

@interface IJMapViewController () <UISearchBarDelegate>
@property(nonatomic) MKMapView *mapView;
@end

@implementation IJMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
  searchBar.barTintColor = kIJumboBlue;
  searchBar.tintColor = [UIColor whiteColor];
  searchBar.delegate = self;
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, searchBar.maxY, self.view.width, self.view.height - searchBar.height)];
  [self.view addSubview:searchBar];
  [self.view addSubview:self.mapView];
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
