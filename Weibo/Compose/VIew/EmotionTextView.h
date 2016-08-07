//
//  EmotionTextView.h
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "PlaceholderTextView.h"
@class Emotion;

@interface EmotionTextView : PlaceholderTextView

- (void)insertEmotion:(Emotion *)emotion;

- (NSString *)fullText;

@end
