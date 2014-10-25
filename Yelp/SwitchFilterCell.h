//
//  SwitchFilterCell.h
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchFilterCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic, copy) void(^valueChangedCallback)(BOOL on);
@property (nonatomic, assign) BOOL turnOffable;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
