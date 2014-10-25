//
//  FiltersViewController.m
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchFilterCell.h"
#import "YelpCategoriesFactory.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *filtersTableView;

@property (nonatomic, strong) NSMutableArray *filterCategories;
@property (nonatomic, assign) YelpFiltersSortBy filterSortBy;
@property (nonatomic, assign) NSUInteger filterDistance;
@property (nonatomic, assign) BOOL filterDeal;

@property (nonatomic, assign) BOOL showAllCategories;
@property (nonatomic, strong) UITableViewCell *showAllCategoriesCell;
@property (nonatomic, strong) UILabel *showAllCategoriesLabel;

@property (nonatomic, assign) BOOL showAllSortBy;
@property (nonatomic, assign) BOOL showAllDistances;

@property (nonatomic, copy) FiltersViewControllerCallback filtersChangeCallback;

@end

@implementation FiltersViewController

+ (NSArray *)_filterDistances {
  static NSArray *distances;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    distances = @[@(YelpFiltersDistanceAuto), @(500), @(1000), @(3000), @(10000)];
  });
  return distances;
}

- (instancetype)initWithFilters:(YelpFilters *)filters changeCallback:(FiltersViewControllerCallback)callback {
  if (self = [super init]) {
    _filterCategories = [NSMutableArray arrayWithArray:filters.categories];
    _filterSortBy = filters.sortBy;
    _filterDistance = filters.distance;
    _filterDeal = filters.dealOnly;
    _filtersChangeCallback = callback;

    _filtersTableView = [[UITableView alloc] init];
    _filtersTableView.dataSource = self;
    _filtersTableView.delegate = self;

    _showAllCategoriesCell = [[UITableViewCell alloc] init];

    _showAllCategoriesLabel = [[UILabel alloc] init];
    _showAllCategoriesLabel.text = @"Show All";
  }
  return self;
}

- (void)loadView {
  [super loadView];

  self.view = self.filtersTableView;

  UINavigationItem *navigationItem = self.navigationItem;
  navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButtonTap)];

  [self.showAllCategoriesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.showAllCategoriesCell.contentView addSubview:_showAllCategoriesLabel];

  [self.showAllCategoriesCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.showAllCategoriesLabel
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.showAllCategoriesCell.contentView
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                    multiplier:1
                                                                                      constant:0]];

  [self.showAllCategoriesCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.showAllCategoriesLabel
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.showAllCategoriesCell.contentView
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                    multiplier:1
                                                                                      constant:0]];
}

#pragma mark - callbacks

- (void)onSearchButtonTap {
  if (self.filtersChangeCallback) {
    self.filtersChangeCallback([[YelpFilters alloc] initWithCategories:self.filterCategories
                                                                sortBy:self.filterSortBy
                                                              distance:self.filterDistance
                                                              dealOnly:self.filterDeal]);
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return self.showAllCategories ? [YelpCategoriesFactory categories].count : self.filterCategories.count + 1;
    case 1:
      return self.showAllSortBy ? YelpFiltersSortByCount : 1;
    case 2:
      return self.showAllDistances ? [FiltersViewController _filterDistances].count : 1;
    case 3:
      return 1;
    default:
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak FiltersViewController *weakSelf = self;
  NSInteger row = indexPath.row;

  switch (indexPath.section) {
    case 0:
    {
      if (!self.showAllCategories && row == self.filterCategories.count) {
        return self.showAllCategoriesCell;
      }

      SwitchFilterCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell"];
      if (!switchCell) {
        switchCell = [[SwitchFilterCell alloc] initWithReuseIdentifier:@"SwitchFilterCell"];
      }
      NSArray *categories = self.showAllCategories ? [YelpCategoriesFactory categories] : self.filterCategories;
      YelpCategory *category = categories[row];
      switchCell.title = category.name;
      switchCell.valueChangedCallback = ^(BOOL on) {
        if (on) {
          assert(![weakSelf.filterCategories containsObject:category]);
          [weakSelf.filterCategories addObject:category];
        } else {
          assert([weakSelf.filterCategories containsObject:category]);
          [weakSelf.filterCategories removeObject:category];
        }
      };
      switchCell.on = [self.filterCategories containsObject:category];
      switchCell.turnOffable = YES;
      return switchCell;
    }
    case 1:
    {
      SwitchFilterCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell"];
      if (!switchCell) {
        switchCell = [[SwitchFilterCell alloc] initWithReuseIdentifier:@"SwitchFilterCell"];
      }
      YelpFiltersSortBy sortBy = self.showAllSortBy ? row : self.filterSortBy;
      switchCell.title = [self _getSwitchTitleForSortBy:sortBy];
      switchCell.valueChangedCallback = ^(BOOL on) {
        assert(on);
        weakSelf.filterSortBy = sortBy;
        weakSelf.showAllSortBy = NO;
        [weakSelf.filtersTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
      };
      switchCell.on = (sortBy == self.filterSortBy);
      switchCell.turnOffable = NO;
      return switchCell;
    }
    case 2:
    {
      SwitchFilterCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell"];
      if (!switchCell) {
        switchCell = [[SwitchFilterCell alloc] initWithReuseIdentifier:@"SwitchFilterCell"];
      }
      NSUInteger distance = self.showAllDistances ? [[FiltersViewController _filterDistances][row] integerValue] : self.filterDistance;
      switchCell.title = [self _getSwitchTitleForDistance:distance];
      switchCell.valueChangedCallback = ^(BOOL on) {
        assert(on);
        weakSelf.filterDistance = distance;
        weakSelf.showAllDistances = NO;
        [weakSelf.filtersTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
      };
      switchCell.on = (distance == self.filterDistance);
      switchCell.turnOffable = NO;
      return switchCell;
    }
    case 3:
    {
      SwitchFilterCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell"];
      if (!switchCell) {
        switchCell = [[SwitchFilterCell alloc] initWithReuseIdentifier:@"SwitchFilterCell"];
      }
      switchCell.title = [self _getSwitchTitleForGeneralFeaturesSectionAtRow:row];
      switchCell.valueChangedCallback = ^(BOOL on) {
        assert(row == 0);
        weakSelf.filterDeal = on;
      };
      assert(row == 0);
      switchCell.on = self.filterDeal;
      switchCell.turnOffable = YES;
      return switchCell;
    }
    default:
      return nil;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"Category";
    case 1:
      return @"Sort By";
    case 2:
      return @"Distance";
    case 3:
      return @"General Features";
    default:
      return nil;
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  switch (indexPath.section) {
    case 0:
      if (self.showAllCategories || indexPath.row != self.filterCategories.count) {
        return;
      }
      self.showAllCategories = YES;
      break;
    case 1:
      if (self.showAllSortBy || indexPath.row != 0) {
        return;
      }
      self.showAllSortBy = YES;
      break;
    case 2:
      if (self.showAllDistances || indexPath.row != 0) {
        return;
      }
      self.showAllDistances = YES;
      break;
  }
  [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - switch titles

- (NSString *)_getSwitchTitleForSortBy:(YelpFiltersSortBy)sortBy {
  switch (sortBy) {
    case YelpFiltersSortByBestMatch:
      return @"Best Match";
    case YelpFiltersSortByDistance:
      return @"Distance";
    case YelpFiltersSortByRating:
      return @"Rating";
    default:
      return nil;
  }
}

- (NSString *)_getSwitchTitleForDistance:(NSUInteger)distance {
  if (distance == YelpFiltersDistanceAuto) {
    return @"Auto";
  } else {
    if (distance >= 1000) {
      return [NSString stringWithFormat:@"%.0f km", distance / 1000.0];
    } else {
      return [NSString stringWithFormat:@"%ld meters", (long) distance];
    }
  }
}

- (NSString *)_getSwitchTitleForGeneralFeaturesSectionAtRow:(NSInteger)row {
  switch (row) {
    case 0:
      return @"Offering a Deal";
    default:
      return nil;
  }
}

@end
