//
//  IJMapViewController.h
//  iJumbo
//
//  Created by Amadou Crookes on 8/20/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IJMapViewController;

@protocol IJMapViewControllerDelegate <NSObject>
- (void)mapViewController:(IJMapViewController*)mapVC didSearchForText:(NSString*)text;
@end

@interface IJMapViewController : UIViewController

@property(nonatomic) id<IJMapViewControllerDelegate> delegate;

- (instancetype)initWithLocations:(NSArray *)locations;
- (void)removeLocationsFromMap;

@end
