//
//  PlaceholderTextView.h
//  Weibo
//
//  Created by ZHANGMIA on 7/31/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  增强版的textView: 带有占位文字

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic,copy)NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic,strong)UIColor *placeholderColor;

@end
