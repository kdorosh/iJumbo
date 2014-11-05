//
//  IJEventTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/15/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJEventTableViewController.h"

#import "IJDatePicker.h"
#import "IJEvent.h"
#import "IJEventTableViewCell.h"
#import "IJEventViewController.h"
#import "IJHelper.h"

static const int kEventsDateNavigationBarHeight = 44;
static const int kEventsDateSecondsInOneDay = (60 * 60 * 24);

static NSDateFormatter *kEventsTableDateFormatter;

@interface IJEventTableViewController () <NSFetchedResultsControllerDelegate>
@property(nonatomic) UILabel *dateLabel;
@property(nonatomic) NSDate *date;
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) IJDatePicker *datePicker;
@property(nonatomic) UIRefreshControl *refreshControl;
@end

@implementation IJEventTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Events";
  [self addTableViewWithDelegate:self];
  
  UIBarButtonItem *calendarBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Calendar"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                      action:@selector(showCalendar:)];
  self.navigationItem.rightBarButtonItem = calendarBarButton;
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  [self setupDateNavigationBar];
  self.date = [NSDate date];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(loadData)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  
  [self setupDatePicker];
  
  [self.tableView reloadData];
  [self loadData];
}

- (void)setupDatePicker {
  self.datePicker = [[IJDatePicker alloc] initWithWidth:self.view.width];
  self.datePicker.frame = CGRectMake(0, self.view.maxY, self.view.width, self.datePicker.height);
  self.datePicker.backgroundColor = [UIColor whiteColor];
  self.datePicker.date = [NSDate date];
  self.datePicker.datePickerMode = UIDatePickerModeDate;
  [self.datePicker updatesForDateChangeForTarget:self withAction:@selector(dateChanged:)];
  [self.datePicker.leftButton addTarget:self
                                 action:@selector(hideCalendar:)
                       forControlEvents:UIControlEventTouchUpInside];
  [self.datePicker setLeftButtonTitle:@"Done"];
  self.datePicker.rightButton.hidden = YES;

  [self.view addSubview:self.datePicker];
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
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

- (void)setDateToToday:(id)sender {
  self.date = [NSDate date];
}

- (void)setupDateNavigationBar {
  UIView *dateNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kEventsDateNavigationBarHeight)];
  self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dateNavigationBar.frame.size.width, dateNavigationBar.frame.size.height)];
  self.dateLabel.textAlignment = NSTextAlignmentCenter;
  self.dateLabel.font = [UIFont regularFontWithSize:20];
  self.dateLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
  
  const CGFloat arrowWidth = 14;
  const CGFloat arrowHeight = 22.5;
  const CGFloat arrowPadding = 10;
  const CGFloat arrow_y = (kEventsDateNavigationBarHeight / 2) - (arrowHeight / 2);
  
  // Previous Arrow Image.
  UIImageView *previousButtonImage = [[UIImageView alloc] initWithFrame:CGRectMake(arrowPadding, arrow_y, arrowWidth, arrowHeight)];
  [previousButtonImage setImage:[UIImage imageNamed:@"arrow_left.png"]];
  UIButton *previousDateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, arrow_y, self.view.width/4.0f, arrowHeight)];
  [dateNavigationBar addSubview:previousButtonImage];
  [dateNavigationBar addSubview:previousDateButton];
  
  // Next Arrow Image.
  const CGFloat nextArrow_x = dateNavigationBar.frame.size.width - arrowPadding - arrowWidth;
  UIButton *nextDateButton = [[UIButton alloc] initWithFrame:CGRectMake(3 * (self.view.width/4.0f), arrow_y, self.view.width/4.0f, arrowHeight)];
  UIImageView *nextButtonImage =
      [[UIImageView alloc] initWithFrame:CGRectMake(nextArrow_x, arrow_y, arrowWidth, arrowHeight)];
  [nextButtonImage setImage:[UIImage imageNamed:@"arrow_right.png"]];
  [dateNavigationBar addSubview:nextButtonImage];
  [dateNavigationBar addSubview:nextDateButton];
  
  // Button actions.
  [previousDateButton addTarget:self action:@selector(previousDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [nextDateButton addTarget:self action:@selector(nextDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:dateNavigationBar];
  
  self.tableView.frame = CGRectMake(0, dateNavigationBar.maxY, self.view.width, self.tableView.height - dateNavigationBar.height);
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
    [self.refreshControl endRefreshing];
  } failureBlock:^(NSError *error) {
    [self.refreshControl endRefreshing];
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
    _fetchedResultsController.delegate = self;
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error getting events from core data: %@", error);
    }
  }
  return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSError *error;
  if (![self.fetchedResultsController performFetch:&error] || error) {
    NSLog(@"There was as error updating the links.");
    NSLog(@"%@", error);
  } else {
    [self.tableView mainThreadReload];
  }
}

@end
