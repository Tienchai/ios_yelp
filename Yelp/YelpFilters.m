//
//  YelpFilters.m
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpFilters.h"

const NSUInteger YelpFiltersDistanceAuto = 0;

@implementation YelpFilters

- (instancetype)init {
  return [self initWithCategories:nil sortBy:YelpFiltersSortByBestMatch distance:YelpFiltersDistanceAuto dealOnly:NO];
}

- (instancetype)initWithCategories:(NSArray *)categories sortBy:(YelpFiltersSortBy)sortBy distance:(NSUInteger)distance dealOnly:(BOOL)dealOnly {
  if (self = [super init]) {
    _categories = categories;
    _sortBy = sortBy;
    _distance = distance;
    _dealOnly = dealOnly;
  }
  return self;
}

@end
