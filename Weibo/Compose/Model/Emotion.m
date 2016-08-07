//
//  Emotion.m
//  Weibo
//
//  Created by ZHANGMIA on 8/3/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Emotion.h"

@implementation Emotion

MJCodingImplementation

///** 
// 从文件中解析对象时调用 
// */
//- (instancetype)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
////        self.chs = [decoder decodeObjectForKey:@"chs"];
////        self.png = [decoder decodeObjectForKey:@"png"];
////        self.code = [decoder decodeObjectForKey:@"code"];
//        
//        [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//            ivar.value = [decoder decodeObjectForKey:ivar.name];
//        }];
//    }
//    return self;
//}
//
///** 
// 将对象写入文件的时候调用 
// */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.chs forKey:@"chs"];
//    [encoder encodeObject:self.png forKey:@"png"];
//    [encoder encodeObject:self.code forKey:@"code"];
//}


/**
 *   常用来比较两个对象是否一样
 *
 *   @param other 另外一个Emotion对象
 */
- (BOOL)isEqual:(Emotion *)other
{
    return ([self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code]);
}

@end
