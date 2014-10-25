//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "YelpCategoriesFactory.h"


@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
  NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
  self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
  if (self) {
    BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
    [self.requestSerializer saveAccessToken:token];
  }
  return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                   filters:(YelpFilters *)filters
                                   success:(void (^)(AFHTTPRequestOperation *, id))success
                                   failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"37.774866,-122.394556", @"ll",
                                     @(filters.sortBy), @"sort",
                                     @(filters.dealOnly), @"deals_filter",
                                     nil];

  if (term) {
    [parameters setObject:term forKey:@"term"];
  }

  if (filters.categories.count > 0) {
    NSMutableArray *categoryIdentifiers = [NSMutableArray arrayWithCapacity:filters.categories.count];
    for (YelpCategory *category in filters.categories) {
      [categoryIdentifiers addObject:category.identifier];
    }
    [parameters setObject:[categoryIdentifiers componentsJoinedByString:@","] forKey:@"category_filter"];
  }

  if (filters.distance != YelpFiltersDistanceAuto) {
    [parameters setObject:@(filters.distance) forKey:@"radius_filter"];
  }

  return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
