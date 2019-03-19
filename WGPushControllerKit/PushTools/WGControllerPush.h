//
//  WGControllerPush.h
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/5.
//  Copyright © 2018年 wanggang. All rights reserved.
//

//属性传值关键字
#define WGProperty @"property"
//修改初始化方法关键字
#define WGInitWith @"initWith"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -传值类型
typedef NS_ENUM(NSInteger , WGPushControllerType) {
    WGPushNoParam     = 0, //不需要传值
    WGPushProperty   = 1, //只有属性传值
    WGPushInit     = 2, //重写了init方法传值
    WGPushOther  = 3, //其他，混合方式传值(既有属性又有initWith)等
};

@interface WGControllerPush : NSObject

+ (WGControllerPush *)WGControllerPushShare;

#pragma mark -不需要传值的话直接调这个接口
/**
 不需要传值页面跳转
 @param fromCon 当前页面
 @param toCon push到的页面
 */
- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon;


/**
 swift类,不需要传值页面跳转

 @param fromCon 当前页面
 @param toCon push到的页面
 @param appName 工程名字
 */
- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon appName:(NSString *)appName;

#pragma mark -需要传值的话直接调这个接口

/**
 通用页面跳转

 @param fromCon 当前页面
 @param toCon push到的页面
 @param type push页面传值类型
 @param paramDic 传值字典
 @param appName 工程名字
 */
- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon paramType:(WGPushControllerType)type param:(NSDictionary *)paramDic appName:(NSString *)appName;

/**
 根据类名字获取其对应的UIViewController
 @param conName 指定的类名字
 @param type 页面传值类型
 @param paramDic 传值字典
 @return 类对象
 */
- (UIViewController *)getViewControllerWithConName:(NSString *)conName paramType:(WGPushControllerType)type param:(NSDictionary *)paramDic appName:(NSString *)appName;

@end
