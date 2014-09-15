//
//  IJRecord.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJRecord.h"

static NSDateFormatter* IJRecordDateFormatter;

@implementation IJRecord

+ (NSString*)keyPathForResponseObject {
  return nil;
}

+ (NSDateFormatter *)dateFormatter {
  if (!IJRecordDateFormatter) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    IJRecordDateFormatter = dateFormatter;
  }
  return IJRecordDateFormatter;
}

@end