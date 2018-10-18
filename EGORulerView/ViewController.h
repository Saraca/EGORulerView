//
//  ViewController.h
//  EGORulerView
//
//  Created by RLY on 2018/10/17.
//  Copyright © 2018年 RLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGORulerView;
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet EGORulerView *rulerView;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;

@end

