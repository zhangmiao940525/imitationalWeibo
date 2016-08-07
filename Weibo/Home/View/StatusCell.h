//
//  StatusCell.h
//  Weibo
//
//  Created by ZHANGMIA on 7/20/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;

@interface StatusCell : UITableViewCell

// 微博的frame模型
@property (nonatomic,strong)StatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
