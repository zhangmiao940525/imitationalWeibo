//
//  EmotionPopView.h
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@class EmotionButton;

@interface EmotionPopView : UIView

+ (instancetype)popView;
- (void)showFrom:(EmotionButton *)button;

@end
