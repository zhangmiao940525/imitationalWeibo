//
//  HomeViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "HomeViewController.h"
#import "DropdownMenu.h"
#import "TitleMenuViewController.h"
#import "AccountTool.h"
#import "TitleButton.h"
#import "User.h"
#import "Status.h"
#import "LoadMoreFooter.h"
#import "StatusCell.h"
#import "StatusFrame.h"
#import "HttpTool.h"

@interface HomeViewController ()<DropdownMenuDelegate>
/**
 *   微博数组（里面放的都是"StatusFrame模型"，一个"StatusFrame模型"就代表一条微博）
 */
@property (nonatomic,strong)NSMutableArray *statusFrame;

@end

@implementation HomeViewController

- (NSMutableArray *)statusFrame
{
    if (!_statusFrame) {
        self.statusFrame = [NSMutableArray array];
    }
    return _statusFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HWColor(211, 211, 211);
    //self.tableView.contentInset = UIEdgeInsetsMake(StatusCellMargin, 0, 0, 0);
    // 设置导航栏内容
    [self setupNav];
    
    // 获得用户信息（昵称）
    [self setupUserInfo];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
//    // 获得未读数
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    // 主线程也会抽时间处理一下timer （不管主线程是否正在处理其它事件）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *   获得未读数
 */
- (void)setupUnreadCount
{
    // 1. 拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2. 发送请求参数
    [HttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 设置提醒数字（微博的未读数）
        // NSNumber --> NSString
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，则清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }

    } failure:^(NSError *error) {
        NSLog(@"请求失败 = %@", error);
    }];
}

/**
 *   集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    // 实例化footer footer会调用注册方法
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
//    [self.tableView addFooterWithCallback:^{
//        NSLog(@"进入上拉刷新状态");
//    }];
//    LoadMoreFooter *footer = [LoadMoreFooter footer];
//    footer.hidden = YES;
//    self.tableView.tableFooterView = footer;
}

/**
 *   集成下拉刷新控件 
 */
- (void)setupDownRefresh
{
    // 1. 添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    // 2. 进入刷新状态
    [self.tableView headerBeginRefreshing];

}

/* // 将Status模型 转为 StatusFrame模型 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (Status *status in statuses) {
        StatusFrame *f = [[StatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

/**
 *   UIRefreshControl 进入刷新状态: 加载最新的数据
 */
- (void)loadNewStatus
{
    // 1. 拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    StatusFrame *firstStatusFrm = [self.statusFrame firstObject];
    
    if (firstStatusFrm) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusFrm.status.idstr;
    }

    // 2. 发送网络请求
    [HttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        // 将 "微博字典" 数组 转为 "微博模型" 数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        // 将newStatus数组 转为 StatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrame insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 显示最新微博的数量
        [self showNewStatusCount:(int)newStatuses.count];
        

    } failure:^(NSError *error) {
        NSLog(@"请求失败 = %@", error);
        // 结束刷新
        [self.tableView headerEndRefreshing];

    }];

}



/**
 *   加载更多的微博数据（上拉）
 *   access_token=2.00BSyX4DCKkODB89aa7be99dAfyk8C
 */
- (void)loadMoreStatus

{
    // 1. 拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    StatusFrame *lastStatusFrm = [self.statusFrame lastObject];
    if (lastStatusFrm) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusFrm.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3. 发送请求参数
    [HttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        // 将 "微博字典" 数组 转为 "微博模型" 数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:json[@"statuses"]];
        // 将Status数组 转为 StatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrame addObjectsFromArray:newFrames];
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败 = %@", error);
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    }];
}

/**
 *   显示最新微博的数量
 *
 *   @param count 最新微博的数量
 */
- (void)showNewStatusCount:(int)count
{
    // 刷新成功（清空图标的数字）
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1. 创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2. 设置其它属性
    if (count == 0) {
        label.text = [NSString stringWithFormat:@"没有新的微博数据"];
    } else {
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据", count];
    }
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter; // 文字居中
    label.font = [UIFont systemFontOfSize:16];
    
    // 3. 添加
    label.y = 64 - label.height;
    
    // 将label添加到导航控制器的view中，并且盖在导航栏下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4. 动画
    CGFloat duration = 1.0; // 动画时间
    [UIView animateWithDuration:duration animations:^{
        //
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear: 匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 回到原来位置
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
    }];
}


/*
 获得用户信息（昵称）
 https://api.weibo.com/2/users/show.json
 */

- (void)setupUserInfo
{
    // 1. 拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2. 发送请求参数
    [HttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        User *user = [User objectWithKeyValues:json];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [AccountTool saveAccount:account];
        
    } failure:^(NSError *error) {
         NSLog(@"请求失败 = %@", error);
    }];
}
/*
 设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题 */
    TitleButton *titleButton = [[TitleButton alloc] init];
    // 设置图片和文字
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    
    // 添加标题的点击监听事件
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    
}

- (void)titleClick:(UIButton *)titleButton
{
    // 1. 设置下拉菜单
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;
    // 2. 设置内容
    TitleMenuViewController *vc = [[TitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    // 3. 显示
    [menu showFrom:titleButton];
}

- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

#pragma mark -DropdownMenuDelegate
/*下拉菜单被销毁*/
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu
{
    //让箭头向下
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}
/*下拉菜单显示了*/
- (void)dropdownMenuDidShow:(DropdownMenu *)menu
{
    //让箭头向上
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.statusFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /** 1.创建cell */

    StatusCell *cell = [StatusCell cellWithTableView:tableView];
    /** 2.给cell传递模型数据 */
    cell.statusFrame = self.statusFrame[indexPath.row];
    
    /** 3.返回给cell */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusFrame *frame = self.statusFrame[indexPath.row];
    return  frame.cellHeight;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//     //    scrollView == self.tableView == self.vie
//    // 如果scrollView还没有数据 就直接返回
//    if (self.statusFrame.count == 0 || self.tableView.tableFooterView.isHidden == NO) {
//        return;
//    }
//    CGFloat offsetY = scrollView.contentOffset.y;
//    // 当最后一个cell完全显示在眼前时， contentOffset的y值
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
//        // 显示footer
//        self.tableView.tableFooterView.hidden = NO;
//
//        // 加载更多微博数据
//        [self loadMoreStatus];
//    }
//}


/**
 1.将字典转为模型
 2.能够下拉刷新最新的微博数据
 3.能够上拉加载更多的微博数据
 */
@end
