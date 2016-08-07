
//
//  ProfileViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ProfileViewController.h"
#import "Test1ViewController.h"
#import "DropdownMenu.h"
#import "HwSearchBar.h"

@interface ProfileViewController ()

@property (nonatomic,strong) HwSearchBar *searchBar;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:self action:@selector(setting)];
    
    HwSearchBar *searchBar = [HwSearchBar searchBar];
    searchBar.width = 300;
    searchBar.height = 30;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
}

- (void)setting
{
    Test1ViewController *test1 = [[Test1ViewController alloc] init];
    test1.title = @"test1";
    [self.navigationController pushViewController:test1 animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
