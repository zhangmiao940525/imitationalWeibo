//
//  EmotionAttachment.h
//  Weibo
//
//  Created by ZHANGMIA on 8/6/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;

@interface EmotionAttachment : NSTextAttachment
//表情模型
@property (nonatomic,strong)Emotion *emotion;

@end
