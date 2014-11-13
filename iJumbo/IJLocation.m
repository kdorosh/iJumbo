//
//  IJLocation.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJLocation.h"

#import <AddressBook/AddressBook.h>

#import "IJHelper.h"
#import "IJServer.h"

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
  // Delete records that do not have longitude or latitude.
  MMRecordOptions *options = [IJLocation defaultOptions];
  options.deleteOrphanedRecordBlock = ^(MMRecord *orphan,
                                        NSArray *populatedRecords,
                                        id responseObject,
                                        BOOL *stop) {
    IJLocation *location = (IJLocation *)orphan;
    if (location.latitude.integerValue == 0 && location.longitude.integerValue == 0) {
      return YES;
    }
    return NO;
  };
  [IJLocation startRequestWithURN:@"/locations"
                             data:nil
                          context:[IJHelper mainContext]
                           domain:nil
                      resultBlock:successBlock
                     failureBlock:errorBlock];
}

+ (void)seedDatabaseWithLocalLocations {
  [IJLocation startRequestWithURN:@"locations"
                             data:nil
                          context:[IJHelper mainContext]
                           domain:IJServerDomainCodeLocalJSONRequest
                      resultBlock:^(NSArray *records) {
                        NSLog(@"%@", records);}
                     failureBlock:^(NSError *error) {}];
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
