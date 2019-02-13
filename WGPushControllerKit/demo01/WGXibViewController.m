//
//  WGXibViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2019/2/13.
//  Copyright © 2019 wanggang. All rights reserved.
//

#import "WGXibViewController.h"

@interface WGXibViewController ()

@property (nonatomic, strong) NSString *name;

@end

@implementation WGXibViewController

- (instancetype)initWithName:(NSString *)name{
    
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WGControllerPush支持xib";
    NSLog(@"age:%ld---->name:%@", self.age, self.name);
    
    NSString *remindStr = [NSString stringWithFormat:@"age:%ld---->name:%@", self.age, self.name];
    
    //我只是为了显示传过来的内容.所以就用UIAlertView了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接收过来的值" message:remindStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
