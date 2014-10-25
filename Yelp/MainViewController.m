//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"

#import "BusinessCell.h"
#import "FiltersViewController.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) YelpFilters *filters;

@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *businessesTableView;

@end

@implementation MainViewController

- (id)init {
  self = [super init];
  if (self) {
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    _client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    _filters = [[YelpFilters alloc] init];
    _searchTerm = @"";
    [self _search];
  }
  return self;
}

- (void)loadView {
  [super loadView];

  UINavigationItem *navigationItem = self.navigationItem;
  navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonTap)];

  self.searchBar = [[UISearchBar alloc] init];
  self.searchBar.delegate = self;
  self.searchBar.showsCancelButton = YES;
  self.searchBar.text = self.searchTerm;
  navigationItem.titleView = self.searchBar;

  self.businessesTableView = [[UITableView alloc] init];
  self.businessesTableView.dataSource = self;
  self.businessesTableView.delegate = self;
  self.view = self.businessesTableView;
}

- (void)_search {
  [self.client searchWithTerm:self.searchTerm
                      filters:self.filters
                      success:^(AFHTTPRequestOperation *operation, id response) {
                        self.businesses = [response valueForKey:@"businesses"];
                        [self.businessesTableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"error: %@", [error description]);
                      }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  self.searchBar.text = self.searchTerm;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  self.searchTerm = self.searchBar.text;
  [self _search];
  [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BusinessCell *businessCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
  if (!businessCell) {
    businessCell = [[BusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessCell"];
  }
  businessCell.index = indexPath.row;
  businessCell.business = self.businesses[indexPath.row];
  return businessCell;
}

#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *businessCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  CGSize size = [businessCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size.height + 1;
}

#pragma mark - callbacks

- (void)onFilterButtonTap {
  FiltersViewController *fvc = [[FiltersViewController alloc] initWithFilters:self.filters changeCallback:^(YelpFilters *filters) {
    self.filters = filters;
    [self _search];
  }];
  [self.navigationController pushViewController:fvc animated:YES];
}

@end
