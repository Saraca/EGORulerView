//
//  ViewController.m
//  EGORulerView
//
//  Created by RLY on 2018/10/17.
//  Copyright © 2018年 RLY. All rights reserved.
//

#import "ViewController.h"
#import "RulerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) selfWeak = self;
    // 用的故事版加载的，异步处理下frame
    dispatch_async(dispatch_get_main_queue(), ^{
        //[_rulerView configWithMinValue:103 maxValue:102 step:1 stepDotNum:10 intervalStepNum:10];
        //[_rulerView configWithMinValue:9 maxValue:101 step:1 stepDotNum:10 intervalStepNum:10];
        [selfWeak.rulerView configWithMinValue:4 maxValue:152 step:2 stepDotNum:10 intervalStepNum:6];
//        [selfWeak.rulerView configWithMinValue:4.5 maxValue:150.9 step:0.3 stepDotNum:10 intervalStepNum:10];
    });
    [_rulerView setSelectValueBlock:^(CGFloat value) {
        selfWeak.labelValue.text = [NSString stringWithFormat:@"%.1f", value];
    }];
    
    // 红线的中线
    UIView *redLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x - 1, 3, 2, 32)];
    redLine.backgroundColor = [UIColor redColor];
    [_rulerView addSubview:redLine];
}


@end
