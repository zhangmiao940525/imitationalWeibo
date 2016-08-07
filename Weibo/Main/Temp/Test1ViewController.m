//
//  Test1ViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    Test2ViewController *test2 = [[Test2ViewController alloc] init];
    test2.title = @"test2控制器";
    [self.navigationController pushViewController:test2 animated:YES];
}

@end
