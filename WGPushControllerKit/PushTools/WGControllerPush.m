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

- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon projName:(NSString *)projName{
    
    [self pushFromController:fromCon toCon:toCon paramType:WGPushNoParam param:nil projName:projName];
}

- (void)pushFromController:(UIViewController *)fromCon toCon:(NSString *)toCon paramType:(WGPushControllerType)type param:(NSDictionary *)paramDic projName:(NSString *)projName{
    if (!toCon || toCon.length == 0) {
        return;
    }
    UIViewController *con = [self getViewControllerWithConName:toCon paramType:type param:paramDic projName:projName];
    if (con) {
        [fromCon.navigationController pushViewController:con animated:YES];
    }
}

- (UIViewController *)getViewControllerWithConName:(NSString *)conName paramType:(WGPushControllerType)type param:(NSDictionary *)paramDic projName:(NSString *)projName{
    
    if (!conName || conName.length == 0) {
        return nil;
    }
    NSString *targetStr = nil;
    if (projName && projName.length>0) {
        targetStr = [NSString stringWithFormat:@"%@.%@",projName, conName];
    }else{
        targetStr = conName;
    }
    
    //根据类名转化为Class类型
    Class classCon = NSClassFromString(targetStr);
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
        return con;
    }else{
        return nil;
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
            //如果是数字则在字典中是NSNumber类型,需要把NSNumber类型转为NSInteger或者CGFloat等
            if ([value isKindOfClass:[NSNumber class]]) {
                
                NSString *keyType = [self getPropertyType:key inObject:toCon];
                NSString *valueStr = [(NSNumber *) value stringValue];

                if (keyType) {
                    if ([keyType containsString:@"NSString"]) {
                        void (*action)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
                        action(toCon, method, valueStr);
                    }else if ([keyType containsString:@"CGFloat"]){
                        CGFloat val = [valueStr doubleValue];
                        void (*action)(id, SEL, CGFloat) = (void (*)(id, SEL, CGFloat)) objc_msgSend;
                        action(toCon, method, val);
                    }else if ([keyType containsString:@"int"]){
                        int val = [(NSNumber *)value intValue];
                        void (*action)(id, SEL, int) = (void (*)(id, SEL, int)) objc_msgSend;
                        action(toCon, method, val);
                    }else if ([keyType containsString:@"float"]){
                        float val = [value floatValue];
                        void (*action)(id, SEL, float) = (void (*)(id, SEL, float)) objc_msgSend;
                        action(toCon, method, val);
                    }else if ([keyType containsString:@"NSNumber"]){
                        void (*action)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
                        action(toCon, method, value);
                    }else{
                        NSInteger val = [(NSNumber *)value integerValue];
                        void (*action)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger)) objc_msgSend;
                        action(toCon, method, val);
                    }
                }else{
                    void (*action)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
                    action(toCon, method, value);
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
                        id (*action)(id, SEL, id) = (id(*)(id, SEL, id)) objc_msgSend;
                        toCon = action(classAlloc, sel_registerName(ky), paramOne);
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

//获取属性类型
- (NSString *)getPropertyType:(NSString *)property inObject:(id)obj{
    
    NSString *type = nil;
    
    if (!property || !obj || property.length == 0) {
        return type;
    }
    
    objc_property_t pro = class_getProperty([obj class], property.UTF8String);
    //属性
    const char *property_attr = property_getAttributes(pro);
    
    if (property_attr[1] == '@') {
        //如果是OC类的类型,则截取子字符串得到真实类型
        char * occurs1 =  strchr(property_attr, '@');
        char * occurs2 =  strrchr(occurs1, '"');
        char dest_str[40]= {0};
        strncpy(dest_str, occurs1, occurs2 - occurs1);
        char * realType = (char *)malloc(sizeof(char) * 50);
        int i = 0, j = 0, len = (int)strlen(dest_str);
        for (; i < len; i++) {
            if ((dest_str[i] >= 'a' && dest_str[i] <= 'z') || (dest_str[i] >= 'A' && dest_str[i] <= 'Z')) {
                realType[j++] = dest_str[i];
            }
        }
        type = [NSString stringWithUTF8String:realType];
        free(realType);
    } else {
        //根据如下链接,获得对应的属性类型https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
        type = [self getPropertyRealType:property_attr];
    }
    return type;
}

- (NSString *)getPropertyRealType:(const char *)property_attr {
    NSString *type;
    
    char t = property_attr[1];
    
    if (t == 'c') {
        type = @"char";
    } else if (t == 'i') {
        type = @"int";
    } else if (t == 's') {
        type = @"short";
    } else if (t == 'l') {
        type = @"long";
    } else if (t == 'q') {
        //long long
        type = @"NSInteger";
    } else if (t == 'C') {
        type = @"unsigned char";
    } else if (t == 'I') {
        type = @"unsigned int";
    } else if (t == 'S') {
        type = @"unsigned short";
    } else if (t == 'L') {
        type = @"unsigned long";
    } else if (t == 'Q') {
        //unsigned long long
        type = @"NSUInteger";
    } else if (t == 'f') {
        type = @"float";
    } else if (t == 'd') {
        type = @"CGFloat";
    } else if (t == 'B') {
        type = @"BOOL";
    } else if (t == 'v') {
        type = @"void";
    } else if (t == '*') {
        type = @"char *";
    } else if (t == '@') {
        type = @"id";
    } else if (t == '#') {
        type = @"Class";
    } else if (t == ':') {
        type = @"SEL";
    } else {
        type = @"";
    }
    return type;
}

@end
