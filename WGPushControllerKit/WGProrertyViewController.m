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
    
    NSString *remindStr = [NSString stringWithFormat:@"name=:%@\n,array=:%@\n,dictionary=:%@\n,ageInt=:%d\n,ageNSIntager=:%d\n,ageCGFloat=:%f\n,ageNSNumber=:%@\n,ageNSString=:%@\n,ageBOOL=:%@\n", self.name, self.array, self.dictionary, self.ageInt, self.ageNSIntager, self.ageCGFloat, self.ageNSNumber, self.ageNSString, self.ageBOOL?@"ageBOOL是YES":@"ageBOOL是NO"];
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收过来的值" message:remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}



@end
