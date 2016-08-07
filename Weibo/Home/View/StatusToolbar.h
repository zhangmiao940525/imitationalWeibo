//
//  StatusToolbar.h
//  Weibo
//
//  Created by ZHANGMIA on 7/29/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface StatusToolbar : UIView

+ (instancetype)toolbar;

@property (nonatomic,strong)Status *status;

@end
