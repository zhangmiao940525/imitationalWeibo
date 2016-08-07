//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by ZHANGMIA on 7/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage
{
    // 设置导航栏上面的内容
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    CGSize size = btn.currentBackgroundImage.size;
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
