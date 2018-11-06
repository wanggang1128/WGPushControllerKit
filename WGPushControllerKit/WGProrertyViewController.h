//
//  WGProrertyViewController.h
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/6.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGProrertyViewController : UIViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dictionary;
//数字在字典中类型为nsnumber,s属性类型设为常用的一下几种类型
@property (nonatomic, assign) int ageInt;
@property (nonatomic, assign) NSInteger ageNSIntager;
@property (nonatomic, assign) CGFloat ageCGFloat;
@property (nonatomic, strong) NSNumber *ageNSNumber;
@property (nonatomic, copy) NSString *ageNSString;
@property (nonatomic, assign) BOOL ageBOOL;


@end
