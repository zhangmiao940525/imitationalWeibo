//
//  EmotionTextView.m
//  Weibo
//
//  Created by ZHANGMIA on 8/4/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "EmotionAttachment.h"

@implementation EmotionTextView

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    // 遍历所有的属性文字（包括图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
      EmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { //图片
            [fullText appendString:attach.emotion.chs];
        } else { // emoji、普通文字
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}

- (void)insertEmotion:(Emotion *)emotion
{
    
    if (emotion.code) {
        // insertText:将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    } else if(emotion.png) {
        
        // 加载图片
        EmotionAttachment *attch = [[EmotionAttachment alloc] init];
        // 传递模型
        attch.emotion = emotion;
        // 设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        // 根据附件 attch 创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];

    }
}

@end
