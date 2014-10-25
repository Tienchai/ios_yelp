//
//  YelpCategoriesFactory.m
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpCategoriesFactory.h"

@implementation YelpCategory

+ categoryWithIdentifier:(NSString *)identifier name:(NSString *)name {
  return [[YelpCategory alloc] initWithIdentifier:identifier name:name];
}

- initWithIdentifier:(NSString *)identifier name:(NSString *)name {
  if (self = [super init]) {
    _identifier = identifier;
    _name = name;
  }
  return self;
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  return [self isEqualToCategory:object];
}

- (NSUInteger)hash {
  return self.identifier.hash;
}

- (BOOL)isEqualToCategory:(YelpCategory *)category {
  return [self.identifier isEqualToString:category.identifier];
}

@end

@implementation YelpCategoriesFactory

+ (NSArray *)categories {
  static NSArray *categories;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    categories = @[
                  [YelpCategory categoryWithIdentifier:@"active" name:@"Active Life"],
                  [YelpCategory categoryWithIdentifier:@"arts" name:@"Arts & Entertainment"],
                  [YelpCategory categoryWithIdentifier:@"auto" name:@"Automotive"],
                  [YelpCategory categoryWithIdentifier:@"beautysvc" name:@"Beauty & Spas"],
                  [YelpCategory categoryWithIdentifier:@"education" name:@"Education"],
                  [YelpCategory categoryWithIdentifier:@"eventservices" name:@"Event Planning & Services"],
                  [YelpCategory categoryWithIdentifier:@"financialservices" name:@"Financial Services"],
                  [YelpCategory categoryWithIdentifier:@"food" name:@"Food"],
                  [YelpCategory categoryWithIdentifier:@"health" name:@"Health & Medical"],
                  [YelpCategory categoryWithIdentifier:@"homeservices" name:@"Home Services"],
                  [YelpCategory categoryWithIdentifier:@"hotelstravel" name:@"Hotels & Travel"],
                  [YelpCategory categoryWithIdentifier:@"localflavor" name:@"Local Flavor"],
                  [YelpCategory categoryWithIdentifier:@"localservices" name:@"Local Services"],
                  [YelpCategory categoryWithIdentifier:@"massmedia" name:@"Mass Media"],
                  [YelpCategory categoryWithIdentifier:@"nightlife" name:@"Nightlife"],
                  [YelpCategory categoryWithIdentifier:@"pets" name:@"Pets"],
                  [YelpCategory categoryWithIdentifier:@"professional" name:@"Professional Services"],
                  [YelpCategory categoryWithIdentifier:@"publicservicesgovt" name:@"Public Services & Government"],
                  [YelpCategory categoryWithIdentifier:@"realestate" name:@"Real Estate"],
                  [YelpCategory categoryWithIdentifier:@"religiousorgs" name:@"Religious Organizations"],
                  [YelpCategory categoryWithIdentifier:@"restaurants" name:@"Restaurants"],
                  [YelpCategory categoryWithIdentifier:@"shopping" name:@"Shopping"],
                  ];
  });
  return categories;
}

@end
