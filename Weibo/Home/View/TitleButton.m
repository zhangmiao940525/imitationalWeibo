//
//  TitleButton.m
//  Weibo
//
//  Created by ZHANGMIA on 7/19/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "TitleButton.h"
#define Margin 5;

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

/*
 如果仅仅是调整按钮内部的titleLabel和imageView的位置
 那么在 layoutSubviews 单独设置位置即可
 */

// 目的: 想在系统计算和设置完按钮的尺寸后，在修改一下尺寸
/**
 *   重写 setFrame 方法的目的: 拦截设置按钮尺寸的过程
 *   如果想在系统设置完控件的尺寸后，在做修改，要想保证修改成功，一般是在 setFrame 中设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.width += Margin;
    [super setFrame:frame];
  //  NSLog(@"%@", NSStringFromCGRect(frame));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 计算titleLabel的frame
    self.titleLabel.x = 0;
    // 2. 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + Margin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
     // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
     // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

/**
 *   设置按钮内部的imageView的frame
 *   设置按钮内部的titleLabel的frame
 *   @param contentRect 按钮的bounds
 */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect

//- (CGRect)titleRectForContentRect:(CGRect)contentRect

@end
