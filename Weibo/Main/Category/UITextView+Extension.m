//
//  UITextView+Extension.m
//  Weibo
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributedText:(NSAttributedString *)text
{
    
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock;
{
    NSMutableAttributedString *attributesText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字(包含图片和普通文字)
    [attributesText appendAttributedString:self.attributedText];
    
    // 拼接其它文字
    NSUInteger loc = self.selectedRange.location;
    //[attributesText insertAttributedString:text atIndex:loc];
    [attributesText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    // 调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributesText);
    }
    
    self.attributedText = attributesText;
    
    // 移除光标到表情的后面
    self.selectedRange = NSMakeRange(loc+1, 0);
}

@end
