//
//  WGOtherViewController.h
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGOtherViewController : UIViewController

@property (nonatomic, copy) NSString *school;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isMale;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
