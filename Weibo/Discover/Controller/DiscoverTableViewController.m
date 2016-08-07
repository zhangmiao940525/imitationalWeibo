//
//  DiscoverTableViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "HwSearchBar.h"

@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 自定义搜索框对象
    HwSearchBar *searchBar = [HwSearchBar searchBar];
    searchBar.width = 400;
    searchBar.height = 30;    
    self.navigationItem.titleView = searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

@end
