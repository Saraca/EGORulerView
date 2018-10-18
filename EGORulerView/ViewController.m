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
    
    // 红线的中线
    __weak typeof(self) selfWeak = self;
    [_rulerView configWithMaxValue:100 minValue:20 step:1 stepDotNum:10 intervalStepNum:10];
    [_rulerView setDidSelectValue:^(CGFloat value) {
        selfWeak.labelValue.text = [NSString stringWithFormat:@"%.1f", value];
    }];
    
    UIView *redLine = [[UIView alloc]initWithFrame:CGRectMake(_rulerView.center.x - 1, 3, 2, 32)];
    redLine.backgroundColor = [UIColor orangeColor];
    [_rulerView addSubview:redLine];
}


@end
