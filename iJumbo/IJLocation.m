//
//  IJLocation.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocation.h"

#import "IJHelper.h"

#import <AddressBook/AddressBook.h>

@implementation IJLocation

@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic phone;
@dynamic website;
@dynamic address;
@dynamic hours;
@dynamic section;

@synthesize coordinate;

+ (void)getLocationsWithSuccessBlock:(void (^)(NSArray *locations))successBlock
                        failureBlock:(void (^)(NSError *error))errorBlock {
  [IJLocation startRequestWithURN:@"/locations"
                             data:nil
                          context:[IJHelper mainContext]
                           domain:nil
                      resultBlock:successBlock
                     failureBlock:errorBlock];
}

- (CLLocationCoordinate2D)coordinate {
  return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (NSString *)title {
  return self.name;
}

- (NSString *)subtitle {
  return self.address;
}

- (MKMapItem*)mapItem {
  NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : self.address};
  
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate
                                                 addressDictionary:addressDict];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = self.title;
  
  return mapItem;
}


@end
