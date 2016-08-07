//
//  NewFeatureViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/14/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "HwTabBarViewController.h"
#define NewFeatureCount 4

@interface NewFeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UIPageControl *pageControl;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.新建一个scrollView，来显示所有新特性的图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2. 添加图片到scrollView里
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < NewFeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i *scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        /* 
         默认情况下，scrollView一旦创建出来，里面可能就存在一些子控件
         就算不主动添加子控件到scrollView中，scrollView内部还是会有一些子控件
         */
        // 如果是最后一个imageView，就往里面添加其它内容
        if (i == NewFeatureCount -1) {
            [self setupLastImageView:imageView];
        }
    }
    // 3. 设置scrollView的属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(NewFeatureCount *scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES; // 自动分页
    scrollView.showsHorizontalScrollIndicator = NO;
    // 成为代理，监听scrollview的滚动
    scrollView.delegate = self;
    
    // 4. 添加pageController分页， 展示目前看的是第几页
    UIPageControl *pageControll = [[UIPageControl alloc] init];
    pageControll.numberOfPages = NewFeatureCount; // 有多少页
    // 页面指示器
    pageControll.currentPageIndicatorTintColor = HWColor(253, 98, 42);
    pageControll.pageIndicatorTintColor = HWColor(189, 189, 189);
    pageControll.centerX = scrollW * 0.5;
    pageControll.centerY = scrollH - 50;
    [self.view addSubview:pageControll];
    self.pageControl = pageControll;
}
// 监听scrollview的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能（imageView默认是不交互的）
    imageView.userInteractionEnabled = YES;
    // 1. 分享给大家（checkbox）
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 190;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:shareBtn];
    
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    /*
     EdgeInsets: 自切
     contentEdgeInsets: 会影响按钮内部的所有内容 （titleLable和imageView）
     titleEdgeInsets: 只影响按钮内部的titleLable的内容
     imageViewEdgeInsets: 只影响按钮内部的imageView的内容
     */
    
    // 2. 开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:startBtn];
}

- (void)shareBtnClick:(UIButton *)shareBtn
{
    // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}
- (void)startClick
{
    // 切换到HwTabBarViewController
    /*
     切换控制器的手段
     1. push 依赖于UINavigationController，控制器的切换是可逆的
     2. modal 控制器的切换是可逆的
     3. 切换window的rootViewController
     */
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[HwTabBarViewController alloc] init];
//    modal方式: 控制器不会被销毁
//    HwTabBarViewController *test = [[HwTabBarViewController alloc] init];
//    [self presentViewController:test animated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

/*
 一个控件用肉眼看不见，有哪些可能？
 1. 根本没有创建实例化这个控件
 2. 没有设置尺寸
 3. 控件的颜色可能和父控件的背景色一样（实际上已经显示了，只不过揉眼看不见）
 4. 透明度alpha小于等于0.01
 5. hidden = YES
 6. 没有添加到父控件中
 7. 被其它控件挡住了
 8. 位置不对
 9. 父控件发生了以上情况
 10. 特殊情况:
 UIImageView没有设置image属性，或者设置的图片名不对
 UILabel没有设置文字，或者文字颜色和父控件背景色一样
 UIPageControll没有设置总页数，也不会显示小圆点
 UIButton内部的imageView和titleLabel的frame被篡改了，或者imageView和titleLabel没有内容
 UITextField没有设置文字，或者没有设置边框样式borderStyle
 ......
 
 添加一个控件的建议（调试技巧）:
 1. 最好设置背景色和尺寸
 2. 控件的颜色尽量不要和父控件颜色一样
 */

@end
