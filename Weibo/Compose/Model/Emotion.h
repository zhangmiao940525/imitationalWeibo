//
//  Emotion.h
//  Weibo
//
//  Created by ZHANGMIA on 8/3/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject<NSCoding>

/** 表情的文字描述 */
@property (nonatomic,copy)NSString *chs;

/** 表情的png图片名 */
@property (nonatomic,copy)NSString *png;

/** emoji 表情的16进制编码 */
@property (nonatomic,copy)NSString *code;

@end
