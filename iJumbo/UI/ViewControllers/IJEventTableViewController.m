//
//  IJEventTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventTableViewController.h"

#import "IJEvent.h"
#import "IJEventTableViewCell.h"
#import "IJEventViewController.h"
#import "IJHelper.h"

static const int kEventsDateNavigationBarHeight = 44;
static const int kEventsDateSecondsInOneDay = (60 * 60 * 24);

static NSDateFormatter *kEventsTableDateFormatter;

@interface IJEventTableViewController ()
@property(nonatomic) UILabel *dateLabel;
@property(nonatomic) NSDate *date;
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) UIDatePicker *datePicker;
@end

@implementation IJEventTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Events";
  [self addTableViewWithDelegate:self];
  
  UIBarButtonItem *calendarBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar:)];
  self.navigationItem.rightBarButtonItem = calendarBarButton;
  
  self.datePicker = [[UIDatePicker alloc] init];
  self.datePicker.frame = CGRectMake(0, self.view.height, self.view.width, self.datePicker.height);
  self.datePicker.backgroundColor = [UIColor whiteColor];
  self.datePicker.date = [NSDate date];
  self.datePicker.datePickerMode = UIDatePickerModeDate;
  [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.datePicker];
  
  CGPoint tableCenter = self.tableView.center;
  CGPoint newTableCenter = CGPointMake(tableCenter.x, tableCenter.y + kEventsDateNavigationBarHeight);
  self.tableView.center = newTableCenter;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  [self setupDateNavigationBar];
  self.date = [NSDate date];
  [self.tableView reloadData];
  [self loadData];
}

- (void)dateChanged:(id)sender {
  self.date = self.datePicker.date;
}

- (void)showCalendar:(id)sender {
  self.navigationItem.rightBarButtonItem.title = @"Hide";
  [self.navigationItem.rightBarButtonItem setAction:@selector(hideCalendar:)];
  [UIView animateWithDuration:0.35 animations:^{
    self.datePicker.frame = CGRectMake(0, self.view.height - self.datePicker.height, self.datePicker.width, self.datePicker.height);
  }];
}

- (void)hideCalendar:(id)sender {
  self.navigationItem.rightBarButtonItem.title = @"Calendar";
  [self.navigationItem.rightBarButtonItem setAction:@selector(showCalendar:)];
  [UIView animateWithDuration:0.35 animations:^{
    self.datePicker.frame = CGRectMake(0, self.view.height, self.datePicker.width, self.datePicker.height);
  }];
}

- (void)setupDateNavigationBar {
  UIView *dateNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kEventsDateNavigationBarHeight)];
  self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dateNavigationBar.frame.size.width, dateNavigationBar.frame.size.height)];
  self.dateLabel.textAlignment = NSTextAlignmentCenter;
  self.dateLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20];
  self.dateLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
  [dateNavigationBar addSubview:self.dateLabel];
  const CGFloat arrowWidth = 50;
  const CGFloat arrowHeight = 20;
  const CGFloat arrowPadding = 20;
  const CGFloat arrow_y = (kEventsDateNavigationBarHeight / 2) - (arrowHeight / 2);
  // TODO(amadou): Make buttons bigger. They are hard to click as of now.
  
  UIButton *previousDateButton = [[UIButton alloc] initWithFrame:CGRectMake(arrowPadding, arrow_y, arrowWidth, arrowHeight)];
  [previousDateButton setImage:[UIImage imageNamed:@"previous_arrow.png"] forState:UIControlStateNormal];
  [dateNavigationBar addSubview:previousDateButton];
  const CGFloat nextArrow_x = dateNavigationBar.frame.size.width - arrowPadding - arrowWidth;
  UIButton *nextDateButton = [[UIButton alloc] initWithFrame:CGRectMake(nextArrow_x, arrow_y, arrowWidth, arrowHeight)];
  [nextDateButton setImage:[UIImage imageNamed:@"next_arrow.png"] forState:UIControlStateNormal];
  [dateNavigationBar addSubview:nextDateButton];
  
  [previousDateButton addTarget:self action:@selector(previousDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [nextDateButton addTarget:self action:@selector(nextDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:dateNavigationBar];
}

- (void)previousDateButtonAction {
  self.date = [NSDate dateWithTimeIntervalSince1970:[self.date timeIntervalSince1970] - kEventsDateSecondsInOneDay];
}

- (void)nextDateButtonAction {
  self.date = [NSDate dateWithTimeIntervalSince1970:[self.date timeIntervalSince1970] + kEventsDateSecondsInOneDay];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)loadData {
  [IJEvent getEventsWithSuccessBlock:^(NSArray *events) {
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView mainThreadReload];
  } failureBlock:^(NSError *error) {
    NSLog(@"Error getting events: %@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[self.fetchedResultsController sections] count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"EventCell";
  IJEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  IJEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell addDataFromEvent:event];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  IJEvent* event = [self.fetchedResultsController objectAtIndexPath:indexPath];
  IJEventViewController *eventVC = [[IJEventViewController alloc] initWithEvent:event];
  [self.navigationController pushViewController:eventVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kEventTableViewCellHeight;
}

- (void)setDate:(NSDate *)date {
  if (!kEventsTableDateFormatter) {
    kEventsTableDateFormatter = [[NSDateFormatter alloc] init];
    [kEventsTableDateFormatter setDateFormat:@"MM/dd"];
  }
  _date = date;
  NSString *dateString = [kEventsTableDateFormatter stringFromDate:_date];
  if (![dateString isEqualToString:self.dateLabel.text]) {
    self.dateLabel.text = dateString;
    [self updateFetchRequestForDate:dateString];
  }
  self.datePicker.date = _date;
}

- (void)updateFetchRequestForDate:(NSString *)dateString {
  self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@", dateString];
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  if (error) {
    NSLog(@"error updating fetch request: %@", error);
  }
  [self.tableView mainThreadReload];
}

- (NSFetchedResultsController*)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext *context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJEvent class])];
    // Configure the request's entity, and optionally its predicate.
    // TODO(amadou): set the date on the backend and enable this again - causing a crash.
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@ AND start > %@", self.dateLabel.text, [NSDate dateWithTimeIntervalSince1970:[self.date timeIntervalSince1970] - kEventsDateSecondsInOneDay]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 25;
    
    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error getting events from core data: %@", error);
    }
  }
  return _fetchedResultsController;
}

//****************************************
//****************************************
#pragma mark - NSFetchedResultsController Delegate
//****************************************
//****************************************

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    default:
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

@end
