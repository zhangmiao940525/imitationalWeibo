//
//  EmotionPageView.h
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//  用来表示一页的表情（里面显示1-20个表情）

#import <UIKit/UIKit.h>
// 一行最多7列
#define EmotionMaxCols 6
// 一页最多3行
#define EmotionMaxRows 4
// 每一页的表情个数
#define  EmotionPageSize ((EmotionMaxRows * EmotionMaxCols) - 1)

@interface EmotionPageView : UIView

/** 这一页显示的表情（里面都是Emotion模型）*/
@property (nonatomic,strong)NSArray *emotions;

@end
