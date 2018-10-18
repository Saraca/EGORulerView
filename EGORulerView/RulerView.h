//
//  RulerView.h
//  NotEatFat
//
//  Created by RLY on 2018/10/15.
//  Copyright © 2018年 RLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGORulerView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) CGFloat       maxValue;       ///< 实际设置能选择的最大值
@property (assign, nonatomic) CGFloat       minValue;       ///< 实际设置能选择的最小值
@property (assign, nonatomic) CGFloat       maxRulerValue;  ///< 能显示的最大值
@property (assign, nonatomic) CGFloat       minRulerValue;  ///< 能显示的最小值
@property (assign, nonatomic) CGFloat       step;           ///< 每两条线相差多少值
@property (assign, nonatomic) CGFloat       stepDotNum;     ///< 一个刻度占多少个屏幕上的点
@property (assign, nonatomic) NSInteger     intervalStepNum; ///< 两条长线之间有多少个刻度
@property (assign, nonatomic, readonly) CGFloat itemCount;   ///< 多少个带有刻度的cell
@property (assign, nonatomic, readonly) CGFloat currentValue;///< 当前尺子的值
@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy,   nonatomic) void (^didSelectValue)(CGFloat);

- (void)setCurrentValueWithoutCallBack:(CGFloat)currentValue animated:(BOOL)animated;
- (void)setCurrentValue:(CGFloat)value animated:(BOOL)animated;
- (void)configWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue step:(CGFloat)step stepDotNum:(CGFloat)stepDotNum intervalStepNum:(NSInteger)intervalStepNum;

@end

