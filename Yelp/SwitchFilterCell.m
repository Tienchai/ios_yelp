//
//  SwitchFilterCell.m
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SwitchFilterCell.h"

@interface SwitchFilterCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UISwitch *filterSwitch;

@end

@implementation SwitchFilterCell

@synthesize title = _title;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super init]) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_titleLabel];

    _filterSwitch = [[UISwitch alloc] init];
    [_filterSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_filterSwitch addTarget:self action:@selector(_onSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_filterSwitch];

    [self setNeedsUpdateConstraints];
  }
  return self;
}

- (void)_onSwitchValueChanged {
  if (!self.turnOffable && !self.filterSwitch.on) {
    self.filterSwitch.on = YES;
    return;
  }

  if (self.valueChangedCallback) {
    self.valueChangedCallback(self.filterSwitch.on);
  }
}

- (void)updateConstraints {
  NSDictionary *viewDictionary = @{@"titleLabel": self.titleLabel,
                                   @"filterSwitch": self.filterSwitch
                                   };

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[titleLabel]-(>=5)-[filterSwitch]-5-|"
                                                               options:NSLayoutFormatAlignAllCenterY
                                                               metrics:nil
                                                                 views:viewDictionary]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[filterSwitch]-(>=5)-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:viewDictionary]];

  [super updateConstraints];
}

- (NSString *)title {
  return _title;
}

- (void)setTitle:(NSString *)title {
  _title = title;
  self.titleLabel.text = _title;
  [self setNeedsLayout];
}

- (void)setOn:(BOOL)on {
  self.filterSwitch.on = on;
}

- (BOOL)isOn {
  return self.filterSwitch.isOn;
}

@end
