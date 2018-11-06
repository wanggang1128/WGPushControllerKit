//
//  ViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/9/5.
//  Copyright © 2018年 wanggang. All rights reserved.
//

//属性传值关键字
#define WGProperty @"property"
//修改初始化方法关键字
#define WGInitWith @"initWith"

#define WGSCREEN [UIScreen mainScreen].bounds.size
#define WGWIDTH [UIScreen mainScreen].bounds.size.width
#define WGHEIGHT [UIScreen mainScreen].bounds.size.height
#define WGNAVHEIGHT (WGHEIGHT==812?88:64) //顶部导航栏高度

#import "ViewController.h"
#import "WGControllerPush.h"
#import "WGModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBaseView];
    [self loadData];
}

- (void)setBaseView{
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    self.dataArr = @[@"不传值", @"只有属性传值", @"只有initWith传值", @"既有property又有initWith方式传值"];
}

#pragma mark -<UITableViewDelegate, UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            [[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGNoParamViewController"];
            break;
        }case 1:{
            //存储属性的字典,属性的名字作为key
            NSDictionary *propertyDic = @{
                                          @"name":@"小明",
                                          @"array":@[@"arr1",@(18.123)],
                                          @"dictionary":@{@"key1":@"value1", @"key2":@(18.123)},
                                          @"ageInt":@(18),
                                          @"ageNSIntager":@(18),
                                          @"ageCGFloat":@(18.123),
                                          @"ageNSNumber":@(18.123),
                                          @"ageNSString":@(18.123),
                                          @"ageBOOL":@(YES)
                                          };
            //外层用@"property"作为key包装,为了识别哪些值需要属性传值
            NSDictionary *paramDic = @{
                                    WGProperty:propertyDic
                                    };
            
            [[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGProrertyViewController" paramType:WGPushProperty param:paramDic];
            break;
        }case 2:{
            //只有init方式传值
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
            
            NSDictionary *paramDic = @{
                                       WGInitWith:initDic
                                       };
            [[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGInitWithViewController" paramType:WGPushInit param:paramDic];
            break;
        }case 3:{
            
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
                                               @"age":@(18),
                                               @"isMale":@(YES)
                                               }
                                       };
            [[WGControllerPush WGControllerPushShare] pushFromController:self toCon:@"WGOtherViewController" paramType:WGPushOther param:paramDic];
            break;
        }
        default:
            break;
    }
}

#pragma mark -懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WGWIDTH, WGHEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}


@end
