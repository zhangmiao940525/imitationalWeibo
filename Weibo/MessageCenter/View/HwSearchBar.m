//
//  HwSearchBar.m
//  Weibo
//
//  Created by ZHANGMIA on 7/11/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "HwSearchBar.h"

@implementation HwSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 自定义搜索框对象
        self.font = [UIFont systemFontOfSize:15];
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder = @"在这里输入要搜索的内容";
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

@end
