//
//  WGInitWithViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGInitWithViewController.h"

@interface WGInitWithViewController ()

@property (nonatomic, copy) NSString *remindStr;

@end

@implementation WGInitWithViewController

- (instancetype)initWithDic:(NSDictionary *)dic model:(WGModel *)model school:(NSString *)school{
    self = [super init];
    if (self) {
        self.remindStr = [NSString stringWithFormat:@"dic:%@\n-->model.name:%@\n-->model.age:%ld\n-->school:%@", dic, model.name, (long)model.age, school];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"只有initWith方式传值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收过来的值" message:self.remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}


@end
