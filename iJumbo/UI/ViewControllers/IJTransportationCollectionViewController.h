//
//  IJTransportationCollectionViewController.h
//  iJumbo
//
//  Created by Amadou Crookes on 9/24/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJTransportationCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic) UICollectionView *collectionView;
+ (NSString *)joeyScheduleFile;
@end
