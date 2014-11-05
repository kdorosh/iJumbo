//
//  IJMenuTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/29/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMenuTableViewController.h"

#import "IJDatePicker.h"
#import "IJFoodItem.h"
#import "IJFoodItemTableViewCell.h"
#import "IJFoodItemViewController.h"
#import "IJMenuSection.h"
#import "IJMyFoodViewController.h"
#import "IJTableViewHeaderFooterView.h"

static const double kDatePickerAnimationDuration = 0.4f;

typedef NS_ENUM(NSInteger, IJMenuActionSheet) {
  IJMenuActionSheetDewick,
  IJMenuActionSheetCarmichael,
  IJMenuActionSheetHodgdon,
  IJMenuActionSheetMyFood
};

@interface IJMenuTableViewController () <UIActionSheetDelegate, NSFetchedResultsControllerDelegate>
@property(nonatomic) UIButton *todayButton;
@property(nonatomic) IJDatePicker *datePicker;
@property(nonatomic) UIBarButtonItem *hallBarButton;
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) NSDate *date;
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) UISegmentedControl *mealSegment;
@property(nonatomic) UISegmentedControl *dateSegment;
@property(nonatomic) NSMutableSet *datesBeingLoaded;
@property(nonatomic) NSDate *pullToRefreshTime;
@end

@implementation IJMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Menus";
  self.date = [NSDate date];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self setupUI];
  [self loadMenus];
  [self subscribeToNotifications];
  [self.tableView mainThreadReload];
}

- (void)subscribeToNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                           selector:@selector(mainThreadReload)
                                               name:kSubscribedToFoodItemNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                           selector:@selector(mainThreadReload)
                                               name:kUnsubscribedToFoodItemNotification
                                             object:nil];
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)setupUI {
  [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
  // Meal selection bar.
  UIView *mealsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
  mealsBackground.backgroundColor = kIJumboBlue;
  self.mealSegment = [[UISegmentedControl alloc]
                          initWithItems:@[@"Breakfast", @"Lunch", @"Dinner"]];
  self.mealSegment.frame = CGRectMake(10, 7.5, self.view.width - 20, 30);
  self.mealSegment.backgroundColor = kIJumboBlue;
  self.mealSegment.tintColor = [UIColor whiteColor];
  [self.mealSegment addTarget:self
                   action:@selector(mealSegmentDidChangeValue:)
         forControlEvents:UIControlEventValueChanged];
  [mealsBackground addSubview:self.mealSegment];
  [self.view addSubview:mealsBackground];

  // Date selection bar.
  self.dateSegment =
      [[UISegmentedControl alloc] initWithItems:@[@"Today", @"Tomorrow", @"Calendar"]];
  self.dateSegment.backgroundColor = [UIColor clearColor];
  [self.dateSegment setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
                                  forState:UIControlStateNormal];
  [self.dateSegment setTitleTextAttributes:@{NSForegroundColorAttributeName : kIJumboBlue}
                                  forState:UIControlStateSelected];
  [self.dateSegment addTarget:self
                       action:@selector(dateSegmentDidChangeValue:)
             forControlEvents:UIControlEventValueChanged];
  self.dateSegment.frame =
      CGRectMake(0, mealsBackground.maxY + 5, self.view.width, self.mealSegment.height);
  self.dateSegment.selectedSegmentIndex = 0;
  self.dateSegment.tintColor = [UIColor clearColor];
  [self.view addSubview:self.dateSegment];

  // Dining hall button.
  self.hallBarButton =
      [[UIBarButtonItem alloc] initWithTitle:@"Dewick"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(hallBarButtonItemClicked:)];
  self.navigationItem.rightBarButtonItem = self.hallBarButton;
  
  // Table View.
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                 self.dateSegment.maxY,
                                                                 self.view.width,
                                                                 self.view.height - self.dateSegment.maxY - self.navigationController.navigationBar.height - 20)];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  
  //self.tableView.separatorColor = [UIColor clearColor];
  [self.view addSubview:self.tableView];
  
  [self setupDatePicker];
  
  self.mealSegment.selectedSegmentIndex = [IJMenuTableViewController mealSegmentBasedOnTime];
}

- (void)setupDatePicker {
  // Date Picker.
  self.datePicker = [[IJDatePicker alloc] initWithWidth:self.view.width];
  self.datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
  self.datePicker.frame = CGRectMake(0, self.view.maxY, self.datePicker.width, self.datePicker.height);
  self.datePicker.backgroundColor = [UIColor whiteColor];
  self.datePicker.date = [NSDate date];
  [self.datePicker updatesForDateChangeForTarget:self
                                      withAction:@selector(datePickerDidChangeValue:)];
  [self.datePicker.leftButton addTarget:self
                                 action:@selector(hideDatePicker)
                       forControlEvents:UIControlEventTouchUpInside];
  [self.datePicker setLeftButtonTitle:@"Done"];
  self.datePicker.rightButton.hidden = YES;
  [self.view addSubview:self.datePicker];

}

+ (NSUInteger)mealSegmentBasedOnTime {
  NSDate *date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:date];
  NSInteger hour = [components hour];
  if (hour < 11) {
    return 0;
  } else if (hour >= 5) {
    return 2;
  } else {
    return 1;
  }
  return 0;
}

- (void)todayButtonAction {
  self.date = [NSDate date];
  self.datePicker.date = self.date;
  [self updateFetchRequest];
  [self hideDatePicker];
  self.dateSegment.selectedSegmentIndex = 0;
}

- (void)datePickerDidChangeValue:(UIDatePicker *)datePicker {
  self.date = datePicker.date;
  [self updateFetchRequest];
}

#pragma mark - Network

- (void)loadMenus {
  NSDate *today = [NSDate date];
  [self startedLoadingDate:today];
  [IJMenuSection getTodaysMenusWithSuccessBlock:^(NSArray *menuSections) {
    [self stoppedLoadingDate:today];
  } failureBlock:^(NSError *error) {
    [self stoppedLoadingDate:today];
    NSLog(@"Could not get menus: %@", error);
  }];
  NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
  [self startedLoadingDate:tomorrow];
  NSString *tomorrowsDateString = [self.dateFormatter stringFromDate:tomorrow];
  [IJMenuSection getMenusForDate:tomorrowsDateString withSuccessBlock:^(NSArray *menuSections) {
    [self stoppedLoadingDate:tomorrow];
  } failureBlock:^(NSError *error) {
    [self stoppedLoadingDate:tomorrow];
    NSLog(@"Could not get menus for tomorrow: %@", error);
  }];
}

- (void)loadMenusForDate:(NSDate *)date {
  IJAssertNotNil(date);
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  [self startedLoadingDate:date];
  [IJMenuSection getMenusForDate:dateString withSuccessBlock:^(NSArray *menuSections) {
    [self stoppedLoadingDate:date];
  } failureBlock:^(NSError *error) {
    [self stoppedLoadingDate:date];
    NSLog(@"error getting menus for date %@", dateString);
  }];
}

#pragma mark - UITableView Delegate/Datasource

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath  *)indexPath {
  static NSString *cellID = @"MenuTableViewControllerCellID";
  IJFoodItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[IJFoodItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:cellID];
  }
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
  NSArray *menuSections = [sectionInfo objects];
  IJMenuSection *menuSection = menuSections[indexPath.section];
  IJFoodItem *foodItem = [menuSection.foodItems.allObjects objectAtIndex:indexPath.row];
  [cell addDataFromFoodItem:foodItem];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
  NSArray *menuSections = [sectionInfo objects];
  return [menuSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[self.fetchedResultsController sections] count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSArray *menuSections = [sectionInfo objects];
    IJMenuSection *menuSection = [menuSections objectAtIndex:section];
    return [menuSection.foodItems count];
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kFoodItemTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kTableViewHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  static NSString *headerIdentifier = @"LocationHeader";
  IJTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
  if (!header) {
    header = [[IJTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
  }
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
  NSArray *menuSections = [sectionInfo objects];
  IJMenuSection *menuSection = [menuSections objectAtIndex:section];
  header.sectionTitleLabel.text = menuSection.name;
  return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
  NSArray *menuSections = [sectionInfo objects];
  IJMenuSection *menuSection = menuSections[indexPath.section];
  IJFoodItem *foodItem = [menuSection.foodItems.allObjects objectAtIndex:indexPath.row];
  IJFoodItemViewController *foodVC = [[IJFoodItemViewController alloc] initWithFoodItem:foodItem];
  [self.navigationController pushViewController:foodVC animated:YES];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self datePickerIsShown]) {
    [self hideDatePicker];
  }
  if (scrollView.contentOffset.y < -60 && [self.pullToRefreshTime timeIntervalSinceNow] < -1) {
    self.pullToRefreshTime = [NSDate date];
    [self loadMenusForDate:[self.date copy]];
  }
}

#pragma mark - UISegmentControl

- (void)mealSegmentDidChangeValue:(UISegmentedControl*)mealSegment {
  [self updateFetchRequest];
}

- (void)dateSegmentDidChangeValue:(UISegmentedControl*)dateSegment {
  if (dateSegment.selectedSegmentIndex == 0) {
    self.date = [NSDate date];
    [self hideDatePicker];
  } else if (dateSegment.selectedSegmentIndex == 1) {
    self.date = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
    [self hideDatePicker];
  } else if (dateSegment.selectedSegmentIndex == 2) {
    [self showDatePicker];
  }
  [self updateFetchRequest];
}

#pragma mark - UIBarButtonItem

- (void)hallBarButtonItemClicked:(UIBarButtonItem*)hallBarButton {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:@"Select Dining Hall"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                         otherButtonTitles:@"Dewick", @"Carmichael", @"Hodgdon", @"My Food", nil];
  [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == IJMenuActionSheetMyFood) {
    NSLog(@"Push the my food view controller.");
    IJMyFoodViewController *myFoodVC = [[IJMyFoodViewController alloc] init];
    [self.navigationController pushViewController:myFoodVC animated:YES];
  } else if (buttonIndex < IJMenuActionSheetMyFood) {
    self.hallBarButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self updateFetchRequest];
  }
}

#pragma mark - UIDatePicker

- (BOOL)datePickerIsShown {
  return (self.datePicker.frame.origin.x + self.navigationController.navigationBar.height
          ==
          self.view.maxY);
}

- (void)showDatePicker {
  [self moveDatePickerToY:self.view.maxY - self.datePicker.height];
}

- (void)hideDatePicker {
  [self moveDatePickerToY:self.view.maxY];
  NSString *dateString = [self.dateFormatter stringFromDate:_date];
  NSString *todayString = [self.dateFormatter stringFromDate:[NSDate date]];
  NSString *tomorrowString =
  [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)]];
  if (![dateString isEqualToString:todayString] && ![dateString isEqualToString:tomorrowString]) {
    [self.dateSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self.dateSegment setTitle:[self.dateFormatter stringFromDate:_date] forSegmentAtIndex:2];
  } else {
    [self.dateSegment setSelectedSegmentIndex:self.dateSegment.selectedSegmentIndex];
    [self.dateSegment setTitle:@"Calendar" forSegmentAtIndex:2];
  }
}

- (void)moveDatePickerToY:(CGFloat)y {
  [UIView animateWithDuration:kDatePickerAnimationDuration
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     self.datePicker.frame = CGRectMake(0,
                                                             y - self.navigationController.navigationBar.height,
                                                             self.datePicker.width,
                                                             self.datePicker.height);
                   } completion:^(BOOL finished) {}];
}

- (void)updateFetchRequest {
  self.fetchedResultsController.fetchRequest.predicate = [self predicateFromUI];
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  if (error) {
    NSLog(@"error updating menu table fetch controller.");
  }
  if ([self.fetchedResultsController.fetchedObjects count] == 0) {
    [self loadMenusForDate:self.date];
  }
  [self.tableView mainThreadReload];
}

- (NSPredicate *)predicateFromUI {
  NSString *dateString = [self.dateFormatter stringFromDate:self.date];
  return [NSPredicate predicateWithFormat:@"date == %@ AND diningHall == %@ AND (meal == %@ OR diningHall = 'Hodgdon')",
            dateString,
            self.hallBarButton.title,
            [self.mealSegment titleForSegmentAtIndex:self.mealSegment.selectedSegmentIndex]];
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

- (void)startedLoadingDate:(NSDate *)date {
  [self.datesBeingLoaded addObject:date];
  if ([self.datesBeingLoaded count] > 0) {
    [self startRefreshUI];
  }
}

- (void)stoppedLoadingDate:(NSDate *)date {
  [self.datesBeingLoaded removeObject:date];
  if ([self.datesBeingLoaded count] == 0) {
    [self stopRefreshUI];
  }
}

- (void)startRefreshUI {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [activityIndicator setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = activityIndicator;
    [activityIndicator startAnimating];
  });
}

- (void)stopRefreshUI {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"Menus";
  });
}

#pragma mark - Getters and Setters

- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-M-d"];
  }
  return _dateFormatter;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSManagedObjectContext * context = [IJHelper mainContext];
    NSFetchRequest *fetchRequest =
        [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([IJMenuSection class])];
    fetchRequest.predicate = [self predicateFromUI];
    // Specify how the fetched objects should be sorted.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionNum"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    fetchRequest.fetchBatchSize = 8;

    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [_fetchedResultsController performFetch:&error];
    if (!success) {
      NSLog(@"Error performing fetch for menu table view controller.");
    }
  }
  return _fetchedResultsController;
}

- (void)setDate:(NSDate *)date {
  _date = date;
  self.datePicker.date = _date;
}
   
- (NSMutableSet *)datesBeingLoaded {
  if (!_datesBeingLoaded) {
    _datesBeingLoaded = [NSMutableSet set];
  }
  return _datesBeingLoaded;
}

- (NSDate *)pullToRefreshTime {
  if (!_pullToRefreshTime) {
    _pullToRefreshTime = [NSDate dateWithTimeIntervalSince1970:0];
  }
  return _pullToRefreshTime;
}

@end
