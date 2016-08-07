//
//  EmotionListView.m
//  Weibo
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionPageView.h"

@interface EmotionListView ()<UIScrollViewDelegate>

/** scrollView */
@property (nonatomic,weak)UIScrollView *scrollView;
/** pageControl */
@property (nonatomic,weak)UIPageControl *pageControl;

@end

@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 1. UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        // 去除水平和垂直方向上的滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        // 成为代理
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2. UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        // 当只有1页时，自动隐藏
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        //pageControl.backgroundColor = [UIColor blueColor];
        // 设置内部的原点图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

// 根据emotions.count, 创建对应个数的表情
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 删除之前的控件
 //   [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + EmotionPageSize - 1) / EmotionPageSize;
    
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i < count; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc] init];
        // 计算这一页的表情范围
        NSRange range;
        
        range.location = i * EmotionPageSize;
        // left: 剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if ( left >= EmotionPageSize) {
            range.length = EmotionPageSize;
        } else {
            range.length = left;
        }
        
        // 设置这一页的表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. UIPageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2. UIScrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = 0;
    self.scrollView.y = 0;
    
    // 3. 设置
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    
    // 4. 设置ScrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"self.scrollView.subviews = %@",self.scrollView.subviews);
}

#pragma mark - scrollview代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

@end
