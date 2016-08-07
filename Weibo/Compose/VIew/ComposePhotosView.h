//
//  ComposePhotosView.h
//  Weibo
//
//  Created by ZHANGMIA on 8/1/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView

- (void)addPhoto:(UIImage *)photo;

//@property (nonatomic,strong)NSArray *photos;

//- (NSArray *)photos;

@property (nonatomic,strong,readonly)NSMutableArray *photos;

@end
