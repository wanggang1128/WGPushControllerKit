 //
//  WGCustomViewController.m
//  WGPushControllerKit
//
//  Created by wanggang on 2018/12/26.
//  Copyright © 2018 wanggang. All rights reserved.
//

#define WGSCREEN [UIScreen mainScreen].bounds.size
#define WGWIDTH [UIScreen mainScreen].bounds.size.width

#import "WGCustomViewController.h"
#import "WGControllerPush.h"

@interface WGCustomViewController ()

@property (nonatomic, strong) UIButton *cusBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation WGCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"后台配置九宫格";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.cusBtn];
    
    [self loadNetData];
    
}

//布局九宫格视图
- (void)reloadView{
    
    CGFloat margin = 15;
    CGFloat width = (WGWIDTH - margin*4)/3;
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, WGWIDTH, (width+margin)*(self.dataArr.count/4+1))];
    _bgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bgView];
    
    for (NSInteger i = 0; i<self.dataArr.count; i++) {
        
        NSDictionary *dataDic = self.dataArr[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((margin+width)*(i%3)+margin, (margin+width)*(i/3)+margin, width, width)];
        
        btn.tag = i;
        
        [btn setTitle:dataDic[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:dataDic[@"defaultImg"]] forState:UIControlStateNormal];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+10 ,-btn.imageView.frame.size.width, 0.0,0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
        
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bgView addSubview:btn];
    }
}

//九宫格按钮功能点击(跳转到对应页面)
- (void)btnClicked:(UIButton *)sender{
    
#warning 看到没,核心代码就这一句即可完成所有功能跳转
    
    NSDictionary *dic = self.dataArr[sender.tag];
    NSString *controllerName = [self getControllerName:dic[@"code"]];
    [[WGControllerPush WGControllerPushShare] pushFromController:self toCon:controllerName projName:nil];
}

//根据后台返回的页面ID得到类名字
- (NSString *)getControllerName:(NSString *)pageId{
    NSDictionary *dic = @{
                          @"1-1":@"WGOneViewController",
                          @"1-2":@"WGTwoViewController",
                          @"1-3":@"WGThreeViewController",
                          @"1-4":@"WGFourViewController",
                          @"1-5":@"WGFiveViewController",
                          @"1-6":@"WGSixViewController"
                          };
    return dic[pageId];
}

//模拟获取后台数据
- (void)loadNetData{
    
    int x = arc4random() % 3;
    
    if (x % 3 == 0) {
        
        NSArray *arr01 = @[
                    @{
                        @"code" : @"1-1",
                        @"defaultImg" : @"Image1",
                        @"name" : @"项目1",
                        },
                    @{
                        @"code" : @"1-2",
                        @"defaultImg" : @"Image2",
                        @"name" : @"项目2",
                        },
                    @{
                        @"code" : @"1-5",
                        @"defaultImg" : @"Image5",
                        @"name" : @"项目5",
                        },
                    @{
                        @"code" : @"1-6",
                        @"defaultImg" : @"Image5",
                        @"name" : @"项目6",
                        },
                    ];
        self.dataArr = arr01;
        
    }else if (x % 3 == 1) {
        
        NSArray *arr02 = @[
                    @{
                        @"code" : @"1-3",
                        @"defaultImg" : @"Image3",
                        @"name" : @"项目3",
                        },
                    @{
                        @"code" : @"1-6",
                        @"defaultImg" : @"Image6",
                        @"name" : @"项目6",
                        },
                    ];
        self.dataArr = arr02;
        
    }else{
        
        NSArray *arr03 = @[
                    @{
                        @"code" : @"1-1",
                        @"defaultImg" : @"Image1",
                        @"name" : @"项目1",
                        },
                    @{
                        @"code" : @"1-2",
                        @"defaultImg" : @"Image2",
                        @"name" : @"项目2",
                        },
                    @{
                        @"code" : @"1-3",
                        @"defaultImg" : @"Image3",
                        @"name" : @"项目3",
                        },
                    @{
                        @"code" : @"1-4",
                        @"defaultImg" : @"Image4",
                        @"name" : @"项目4",
                        },
                    @{
                        @"code" : @"1-5",
                        @"defaultImg" : @"Image5",
                        @"name" : @"项目5",
                        },
                    @{
                        @"code" : @"1-6",
                        @"defaultImg" : @"Image6",
                        @"name" : @"项目6",
                        },
                    ];
        self.dataArr = arr03;
    }
    
    [self reloadView];
}

- (UIButton *)cusBtn{
    if (!_cusBtn) {
        _cusBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
        [_cusBtn setTitle:@"获取后台九宫格数据" forState:UIControlStateNormal];
        [_cusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cusBtn.backgroundColor = [UIColor redColor];
        [_cusBtn addTarget:self action:@selector(loadNetData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cusBtn;
}

@end
