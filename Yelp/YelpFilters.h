//
//  YelpFilters.h
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YelpFiltersSortBy) {
  YelpFiltersSortByBestMatch = 0,
  YelpFiltersSortByDistance = 1,
  YelpFiltersSortByRating = 2,
  YelpFiltersSortByCount = 3, // total number of options
};

extern const NSUInteger YelpFiltersDistanceAuto;

@interface YelpFilters : NSObject

@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, assign, readonly) YelpFiltersSortBy sortBy;
@property (nonatomic, assign, readonly) NSUInteger distance;
@property (nonatomic, assign, readonly) BOOL dealOnly;

- (instancetype)init;
- (instancetype)initWithCategories:(NSArray *)categories sortBy:(YelpFiltersSortBy)sortBy distance:(NSUInteger)distance dealOnly:(BOOL)dealOnly;

@end
