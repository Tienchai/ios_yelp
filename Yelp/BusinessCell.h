//
//  BusinessCell.h
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSDictionary *business;

@end
