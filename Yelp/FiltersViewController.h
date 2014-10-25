//
//  FiltersViewController.h
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpFilters.h"

typedef const void (^FiltersViewControllerCallback)(YelpFilters *filters);

@interface FiltersViewController : UIViewController

- initWithFilters:(YelpFilters *)filters changeCallback:(FiltersViewControllerCallback)callback;

@end
