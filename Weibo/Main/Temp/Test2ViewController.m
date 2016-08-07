//
//  Test2ViewController.m
//  Weibo
//
//  Created by ZHANGMIA on 7/8/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Test2ViewController.h"
#import "Test3TableViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    Test3TableViewController *test3 = [[Test3TableViewController alloc] init];
    test3.title = @"test3控制器";
    [self.navigationController pushViewController:test3 animated:YES];
}

@end
