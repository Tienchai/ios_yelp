//
//  YelpCategoriesFactory.h
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpCategory : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *name;

- (BOOL)isEqualToCategory:(YelpCategory *)category;

@end

@interface YelpCategoriesFactory : NSObject

+ (NSArray *)categories;

@end
