//
//  WGNoParamViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGNoParamViewController.h"

@interface WGNoParamViewController ()

@end

@implementation WGNoParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"没有传值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *remindStr = @"没有传值";
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有传值" message:remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}



@end
