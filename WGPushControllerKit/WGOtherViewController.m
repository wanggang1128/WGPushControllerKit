//
//  WGOtherViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGOtherViewController.h"

@interface WGOtherViewController ()

@property (nonatomic, copy) NSString *str;
@property (nonatomic, copy) NSString *remindStr;

@end

@implementation WGOtherViewController

- (instancetype)initWithDic:(NSDictionary *)dic name:(NSString *) name{
    self = [super init];
    if (self) {
        self.str = [NSString stringWithFormat:@"dic:%@\n-->name:%@\n", dic, name];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"既有property又有initWith方式传值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *remindStr = [NSString stringWithFormat:@"%@-->age:%ld\n-->school:%@\n-->isMale:%@",self.str, self.age, self.school, self.isMale == YES?@"男性":@"女性"];
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收过来的值" message:remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}



@end
