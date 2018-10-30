//
//  WGControllerPush.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/5.
//  Copyright © 2018年 wanggang. All rights reserved.
//

#import "WGControllerPush.h"
#import <objc/message.h>

@implementation WGControllerPush

static WGControllerPush *instance = nil;
+(WGControllerPush *)WGControllerPushShare{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WGControllerPush alloc] init];
    });
    return instance;
}

- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon{
    [self pushFromController:fromCon toCon:toCon paramType:WGPushNoParam param:nil];
}

- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon paramType:(WGPushControllerType)type param:(NSDictionary *)paramDic{
    if (!toCon || toCon.length == 0) {
        return;
    }
    //根据定义好的toCon，拿到类名的字符串
//    NSString *className = [self getControllerName:toCon];
    //根据类名转化为Class类型
    Class classCon = NSClassFromString(toCon);
    //初始化并分配内存
    id con = [[classCon alloc] init];
    //根据HuPushControllerType判断是否有值传到下一页
    switch (type) {
        case WGPushNoParam: {
        } break;
        case WGPushProperty: {
            [self getToConFromProperty:paramDic toCon:con];
        } break;
        case WGPushInit: {
            con = [self getToConFromInit:paramDic classCon:classCon];
        } break;
        case WGPushOther: {
            con = [self getToConFromInit:paramDic classCon:classCon];
            [self getToConFromProperty:paramDic toCon:con];
        } break;
        default:
            break;
    }
    if (con) {
        [fromCon.navigationController pushViewController:con animated:YES];
    }
}

//属性传值
- (void)getToConFromProperty:(NSDictionary *)paramDic toCon:(id)toCon {
    //需要属性传值，则通过运行时来解决
    if (!toCon) {
        return;
    }
    NSDictionary *propertyDic = [paramDic valueForKey:WGProperty];
    NSArray *keyArr = [propertyDic allKeys];
    for (int i = 0; i < keyArr.count; i++) {
        NSString *key = [keyArr objectAtIndex:i];
        id value = [propertyDic valueForKey:key];
        //把key的首字母大写
        NSString *firstStr = [key substringWithRange:NSMakeRange(0, 1)].uppercaseString;
        NSString *restStr = [key substringFromIndex:1];
        //生成对应属性的set方法
        NSString *selName = [NSString stringWithFormat:@"set%@%@:", firstStr, restStr];
        SEL method = NSSelectorFromString(selName);
        if ([toCon respondsToSelector:method]) {
            //等价于controller.shuxing = value;
            //如果是数字则在字典中是NSNumber类型,需要把NSNumber类型转为NSInteger或者CGFloat
            if ([value isKindOfClass:[NSNumber class]]) {
                NSString *vale = [(NSNumber *) value stringValue];
                if ([vale containsString:@"."]) {
                    CGFloat val = [vale doubleValue];
                    void (*action)(id, SEL, CGFloat) = (void (*)(id, SEL, CGFloat)) objc_msgSend;
                    action(toCon, method, val);
                }else{
                    NSInteger val = [(NSNumber *) value integerValue];
                    void (*action)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger)) objc_msgSend;
                    action(toCon, method, val);
                }
            } else {
                void (*action)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
                action(toCon, method, value);
            }
        }
    }
}

//init传值,类似于initWithDic
- (id)getToConFromInit:(NSDictionary *)paramDic classCon:(Class)classCon {
    id toCon = nil;
    NSDictionary *initDic = [paramDic valueForKey:WGInitWith];
    NSString *key = [initDic allKeys].firstObject;
    //把OC的字符串改成C语言的字符串
    const char *ky = [key UTF8String];
    NSArray *value = [initDic valueForKey:key];
    //这里判断value数组元素个数是否和 key按:分割成数组后的个数相等
    if ([key containsString:@":"] && value) {
        if ([key componentsSeparatedByString:@":"].count == (value.count + 1)) {
            switch (value.count) {
                case 1: {
                    //先alloc
                    id classAlloc = ((id (*) (id, SEL))objc_msgSend)(classCon, sel_registerName("alloc"));
                    //sel_registerName(ky)等价于@selecter(ky)
                    if ([classAlloc respondsToSelector:sel_registerName(ky)]) {
                        id paramOne =  [value objectAtIndex:0];
                        if ([paramOne isKindOfClass:[NSNumber class]]) {
                            NSString *val = [(NSNumber *) paramOne stringValue];
                            if ([val containsString:@"."]) {
                                CGFloat vale = [val doubleValue];
                                id (*action)(id, SEL, CGFloat) = (id(*)(id, SEL, CGFloat)) objc_msgSend;
                                //等价于[[class alloc] iniWith:]
                                toCon = action(classAlloc, sel_registerName(ky), vale);
                            }else{
                                id (*action)(id, SEL, NSInteger) = (id(*)(id, SEL, NSInteger)) objc_msgSend;
                                //等价于[[class alloc] iniWith:]
                                toCon = action(classAlloc, sel_registerName(ky), [val integerValue]);
                            }
                        }else{
                            id (*action)(id, SEL, id) = (id(*)(id, SEL, id)) objc_msgSend;
                            toCon = action(classAlloc, sel_registerName(ky), paramOne);
                        }
                    }
                } break;
                case 2: {
                    id classAlloc = ((id (*) (id, SEL))objc_msgSend)(classCon, sel_registerName("alloc"));
                    if ([classAlloc respondsToSelector:sel_registerName(ky)]) {
                        id paramOne = [value objectAtIndex:0];
                        id paramTwo = [value objectAtIndex:1];
                        id (*action)(id, SEL, id, id) = (id(*)(id, SEL, id, id)) objc_msgSend;
                        toCon = action(classAlloc, sel_registerName(ky), paramOne, paramTwo);
                    }
                } break;
                case 3: {
                    id classAlloc = ((id (*) (id, SEL))objc_msgSend)(classCon, sel_registerName("alloc"));
                    if ([classAlloc respondsToSelector:sel_registerName(ky)]) {
                        id (*action)(id, SEL, id, id, id) = (id(*)(id, SEL, id, id, id)) objc_msgSend;
                        toCon = action(classAlloc, sel_registerName(ky), [value objectAtIndex:0], [value objectAtIndex:1], [value objectAtIndex:2]);
                    }
                } break;
                case 4: {
                    id classAlloc = ((id (*) (id, SEL))objc_msgSend)(classCon, sel_registerName("alloc"));
                    if ([classAlloc respondsToSelector:sel_registerName(ky)]) {
                        id (*action)(id, SEL, id, id, id, id) = (id(*)(id, SEL, id, id, id, id)) objc_msgSend;
                        toCon = action(classAlloc, sel_registerName(ky), [value objectAtIndex:0], [value objectAtIndex:1], [value objectAtIndex:2], [value objectAtIndex:3]);
                    }
                } break;
                default:
                    break;
            }
        }
    }
    return toCon;
}


@end
