//
//  LoadMoreFooter.m
//  Weibo
//
//  Created by ZHANGMIA on 7/20/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
