//
//  UITableView+MainThreadReload.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/17/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "UITableView+MainThreadReload.h"

@implementation UITableView (MainThreadReload)

- (void)mainThreadReload {
  [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
