//
//  WGInitWithViewController.h
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGModel.h"

@interface WGInitWithViewController : UIViewController

- (instancetype)initWithDic:(NSDictionary *)dic model:(WGModel *)model school:(NSString *)school;

@end
