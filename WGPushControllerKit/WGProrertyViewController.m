//
//  WGProrertyViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGProrertyViewController.h"

@interface WGProrertyViewController ()

@end

@implementation WGProrertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"只有属性传值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *remindStr = [NSString stringWithFormat:@"name:%@\n-->age:%ld\n-->school:%@\n-->height:%f",self.name, self.age, self.school, self.height];
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收过来的值" message:remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}



@end
