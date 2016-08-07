//
//  EmotionListView.h
//  Weibo
//
//  Created by ZHANGMIA on 8/2/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  表情键盘顶部的所有内容

#import <UIKit/UIKit.h>

@interface EmotionListView : UIView

/** 表情(里面存放的Emotion模型) */
@property (nonatomic,strong)NSArray *emotions;

@end
