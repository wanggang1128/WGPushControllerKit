# WGPushControllerKit
这是一个底层实现页面跳转的工具，通过该工具可以不再import将要跳转页面的头文件，支持常用传值；可以降低文件之间的耦合；有助于组件化；支持个性化配置九宫格菜单

## 效果

![](https://github.com/wanggang1128/WGPushControllerKit/raw/master/WGPushControllerKit/demo.gif)

集成方法：
-----

#### 1、可以直接把工具类PushTools拖入到工程中使用

#### 2、通过cocoapod方式

(1) 首先在Podfile文件中添加 pod 'WGPushControllerKit'

(2) 在项目根目录执行pod install， 即可安装成功

(3) 如果报找不到，请在执行pod install之前，先执行pod repo update

使用：
----

###### 把#import "WGControllerPush.h"导入到工程pch文件中，或者在需要需要跳转的文件导入#import "WGControllerPush.h"

###### 传值分为四种：不需要传值；只通过属性传值；只通过重写init方法传值；既有属性传值也重写了init方法

#### （1）不需要传值

例如一个类

```
@interface WGNoParamViewController : UIViewController

@end
```

在跳转的地方，只需要写如下代码（toCon的参数为需要跳转的页面类名称字符串）
```
[[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGNoParamViewController"];
```

#### （2）只通过属性传值

例如一个类

```
#import <UIKit/UIKit.h>
@interface WGProrertyViewController : UIViewController
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *array;
@end
```

在跳转的地方，只需要写如下代码 

```
//存储属性的字典,属性的名字作为key
NSDictionary *propertyDic = @{
                              @"name":@"小明",
                              @"array":@[@"arr1",@(18.123)]
                              };
//外层用@"property"作为key包装,为了识别哪些值需要属性传值
NSDictionary *paramDic = @{
                        WGProperty:propertyDic
                        };
[[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGProrertyViewController" paramType:WGPushProperty param:paramDic];
```

#### （3）只通过重写init方法传值

```
@interface WGInitWithViewController : UIViewController
- (instancetype)initWithDic:(NSDictionary *)dic model:(WGModel *)model array:(NSString *)array;
@end
```

在跳转的地方，只需要写如下代码 

```
WGModel *model = [[WGModel alloc] init];
model.name = @"小明";
model.age = 18;
//key是重写init的函数名字,值按照顺序放在一个数组中
NSArray *valueArr = @[
                      @{
                          @"height":@(179),
                          @"address":@"人民路"
                          },
                      model,
                      @[@"数组元素",@"18.123"]
                      ];
NSDictionary *initDic = @{
                          @"initWithDic:model:array:":valueArr
                          };
//外层用@"initWith"作为key包装
NSDictionary *paramDic = @{
                           WGInitWith:initDic
                           };
[[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGInitWithViewController" paramType:WGPushInit param:paramDic];
```

#### （4）既有属性传值也重写了init方法

```
@interface WGOtherViewController : UIViewController
@property (nonatomic, copy) NSString *school;
@property (nonatomic, assign) BOOL isMale;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
```

在跳转的地方，只需要写如下代码 

```
NSDictionary *paramDic = @{
                         WGInitWith:@{
                                 @"initWithDic:":@[
                                         @{
                                             @"height":@(179.12),
                                             @"address":@"人民路",
                                             @"hasGirFirend":@(NO)
                                             }
                                         ]
                                 },
                         WGProperty:@{
                                 @"school":@"太和一中",
                                 @"isMale":@(YES)
                                 }
                                       };
[[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGOtherViewController" paramType:WGPushOther param:paramDic];
```
### 链接：可参考https://www.jianshu.com/p/305cce2d513f






