//
//  IJMenuTableViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/29/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJMenuTableViewController.h"

#import "IJFoodItem.h"
#import "IJFoodItemTableViewCell.h"
#import "IJMenuSection.h"
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
@property(nonatomic) UIDatePicker *datePicker;
@property(nonatomic) UIBarButtonItem *hallBarButton;
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) NSDate *date;
@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) UISegmentedControl *mealSegment;
@property(nonatomic) UISegmentedControl *dateSegment;
@end

@implementation IJMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Menus";
  self.date = [NSDate date];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self setupUI];
  [self loadMenus];
  [self.tableView mainThreadReload];
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
  self.mealSegment.selectedSegmentIndex = 0;
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
  self.dateSegment.frame = CGRectMake(0, mealsBackground.maxY + 5, self.view.width, self.mealSegment.height);
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
  
  // Date Picker.
  const int doneButtonHeight = 30;
  self.datePicker = [[UIDatePicker alloc] init];
  self.datePicker.datePickerMode = UIDatePickerModeDate;
  self.datePicker.frame = CGRectMake(0, doneButtonHeight, self.datePicker.width, self.datePicker.height);
  self.datePicker.backgroundColor = [UIColor whiteColor];
  self.datePicker.date = [NSDate date];
  [self.datePicker addTarget:self
                      action:@selector(datePickerDidChangeValue:)
            forControlEvents:UIControlEventValueChanged];
  UIButton *dateDoneButton =
      [[UIButton alloc] initWithFrame:CGRectMake(10, 0, self.datePicker.width/2.0f, doneButtonHeight)];
  dateDoneButton.backgroundColor = [UIColor clearColor];
  [dateDoneButton setTitle:@"Done" forState:UIControlStateNormal];
  [dateDoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [dateDoneButton setTitleColor:kIJumboBlue forState:UIControlStateSelected];
  [dateDoneButton setTitleEdgeInsets:UIEdgeInsetsZero];
  dateDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  [dateDoneButton addTarget:self
                     action:@selector(hideDatePicker)
           forControlEvents:UIControlEventTouchUpInside];
  
  UIView *datePickerBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          self.view.maxY,
                                                                          self.view.width,
                                                                          self.datePicker.height + doneButtonHeight)];
  datePickerBackground.backgroundColor = [UIColor whiteColor];
  [datePickerBackground addSubview:dateDoneButton];
  [datePickerBackground addSubview:self.datePicker];
  [self.view addSubview:datePickerBackground];
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
  [IJMenuSection getTodaysMenusWithSuccessBlock:^(NSArray *menuSections) { }
                                   failureBlock:^(NSError *error) {
    NSLog(@"Could not get menus: %@", error);
  }];
  NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
  NSString *tomorrowsDateString = [self.dateFormatter stringFromDate:tomorrow];
  [IJMenuSection getMenusForDate:tomorrowsDateString withSuccessBlock:^(NSArray *menuSections) { }
                    failureBlock:^(NSError *error) {
    NSLog(@"Could not get menus for tomorrow: %@", error);
  }];
}

- (void)loadMenusForDate:(NSDate *)date {
  NSAssert(date, @"Date cannot be nil.");
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  [IJMenuSection getMenusForDate:dateString withSuccessBlock:^(NSArray *menuSections) { }
                    failureBlock:^(NSError *error) {
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

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self datePickerIsShown]) {
    [self hideDatePicker];
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
  } else if (buttonIndex < IJMenuActionSheetMyFood)
  {
    self.hallBarButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self updateFetchRequest];
  }
}

#pragma mark - UIDatePicker

- (BOOL)datePickerIsShown {
  return (self.datePicker.superview.frame.origin.x + self.navigationController.navigationBar.height
          ==
          self.view.maxY);
}

- (void)showDatePicker {
  [self moveDatePickerToY:self.view.maxY - self.datePicker.superview.height];
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
  UIView *datePickerBackground = self.datePicker.superview;
  [UIView animateWithDuration:kDatePickerAnimationDuration
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     datePickerBackground.frame = CGRectMake(0,
                                                             y - self.navigationController.navigationBar.height,
                                                             datePickerBackground.width,
                                                             datePickerBackground.height);
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
    fetchRequest.fetchBatchSize = 10;

    _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];

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




















@end
