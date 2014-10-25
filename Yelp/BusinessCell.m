//
//  BusinessCell.m
//  Yelp
//
//  Created by Tienchai Wirojsaksaree on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *ratingImageView;
@property (nonatomic, strong) UILabel *reviewCountLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *categoriesLabel;

@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation BusinessCell

@synthesize business = _business;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _previewImageView = [[UIImageView alloc] init];
    _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_previewImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_previewImageView];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.numberOfLines = 0;
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_nameLabel];

    _ratingImageView = [[UIImageView alloc] init];
    _ratingImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_ratingImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_ratingImageView];

    _reviewCountLabel = [[UILabel alloc] init];
    _reviewCountLabel.font = [UIFont systemFontOfSize:10];
    _reviewCountLabel.textColor = [UIColor grayColor];
    [_reviewCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_reviewCountLabel];

    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font = [UIFont systemFontOfSize:10];
    [_locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_locationLabel];

    _categoriesLabel = [[UILabel alloc] init];
    _categoriesLabel.font = [UIFont systemFontOfSize:10];
    _categoriesLabel.textColor = [UIColor grayColor];
    [_categoriesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_categoriesLabel];

    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.font = [UIFont systemFontOfSize:10];
    _distanceLabel.lineBreakMode = NSLineBreakByClipping;
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.textColor = [UIColor grayColor];
    [_distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_distanceLabel];

    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:10];
    _priceLabel.lineBreakMode = NSLineBreakByClipping;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = [UIColor grayColor];
    [_priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_priceLabel];

    [self setNeedsUpdateConstraints];
  }
  return self;
}

- (void)updateConstraints {

  NSDictionary *viewDictionary = @{@"previewImageView": self.previewImageView,
                                   @"nameLabel": self.nameLabel,
                                   @"ratingImageView": self.ratingImageView,
                                   @"reviewCountLabel": self.reviewCountLabel,
                                   @"locationLabel": self.locationLabel,
                                   @"categoriesLabel": self.categoriesLabel,
                                   @"distanceLabel": self.distanceLabel,
                                   @"priceLabel": self.priceLabel,
                                   };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[previewImageView(50)]-(>=5)-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewDictionary]];

  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.previewImageView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1
                                                                constant:0]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[previewImageView]-5-[nameLabel]-(>=5)-[distanceLabel(35)]-5-|"
                                                                           options:NSLayoutFormatAlignAllTop
                                                                           metrics:nil
                                                                             views:viewDictionary]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel]-2-[ratingImageView(10)]-2-[locationLabel]-2-[categoriesLabel]-(>=5)-|"
                                                                           options:NSLayoutFormatAlignAllLeading
                                                                           metrics:nil
                                                                             views:viewDictionary]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ratingImageView(55)]-2-[reviewCountLabel]"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:nil
                                                                             views:viewDictionary]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[distanceLabel]-2-[priceLabel]"
                                                                           options:NSLayoutFormatAlignAllTrailing
                                                                           metrics:nil
                                                                             views:viewDictionary]];
  
  [super updateConstraints];
}

- (void)setBusiness:(NSDictionary *)business {
  _business = business;
  [self.previewImageView setImageWithURL:[NSURL URLWithString:[_business valueForKey:@"image_url"]]];
  self.nameLabel.text = [self _getNameString];
  [self.ratingImageView setImageWithURL:[NSURL URLWithString:[_business valueForKey:@"rating_img_url_small"]]];
  self.reviewCountLabel.text = [self _getReviewCountString];
  self.locationLabel.text = [self _getLocationString];
  self.categoriesLabel.text = [self _getCategoriesString];

  self.distanceLabel.text = [self _getDistanceString];
  self.priceLabel.text = @"$$"; // Yelp does not return a value for this
}

- (NSString *)_getNameString {
  return [NSString stringWithFormat:@"%ld. %@", (long)self.index + 1, [self.business valueForKey:@"name"]];
}

- (NSString *)_getReviewCountString {
  NSInteger reviewCount = [[self.business valueForKey:@"review_count"] integerValue];
  return [NSString stringWithFormat:@"%ld Review%@", (long)reviewCount, reviewCount == 1 ? @"" : @"s"];
}

- (NSString *)_getLocationString {
  NSDictionary *location = [self.business valueForKey:@"location"];
  NSArray *address = [location valueForKey:@"address"];
  NSArray *neighborhoods = [location valueForKey:@"neighborhoods"];

  NSMutableArray *locationComponents = [NSMutableArray arrayWithCapacity:2];
  if (address.count > 0) {
    [locationComponents addObject:address[0]];
  }
  if (neighborhoods.count > 0) {
    [locationComponents addObject:neighborhoods[0]];
  } else {
    [locationComponents addObject:[location valueForKey:@"city"]];
  }
  return [locationComponents componentsJoinedByString:@", "];
}

- (NSString *)_getCategoriesString {
  NSArray *categories = [self.business valueForKey:@"categories"];
  NSMutableArray *categoryNames = [NSMutableArray arrayWithCapacity:categories.count];
  for (NSArray *categoryInfo in categories) {
    [categoryNames addObject:categoryInfo[0]];
  }
  return [categoryNames componentsJoinedByString:@", "];
}

- (NSString *)_getDistanceString {
  double distanceInMeters = [[self.business valueForKey:@"distance"] doubleValue];
  if (distanceInMeters < 100) {
    return [NSString stringWithFormat:@"%.0f m", distanceInMeters];
  } else {
    return [NSString stringWithFormat:@"%.1f km", distanceInMeters / 1000];
  }
}

@end
