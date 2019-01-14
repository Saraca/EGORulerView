//
//  RulerView.m
//  NotEatFat
//
//  Created by RLY on 2018/10/15.
//  Copyright © 2018年 RLY. All rights reserved.
//

#import "RulerView.h"

#ifndef ARGB
#define ARGB(a, r, g, b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

#define kZDRulerTextColor ARGB(1, 128, 129, 130)       // 文字颜色
#define kZDRulerShortLineColor ARGB(1, 128, 129, 130)  // 短线颜色
#define kZDRulerMediumLineColor ARGB(1, 128, 129, 130) // 中长线颜色
#define kZDRulerLongLineColor ARGB(1, 128, 129, 130)   // 长线颜色
#define kZDRulerTextFont [UIFont systemFontOfSize:14]  // 文字字体

const CGFloat kZDRulerLineWidth = 1.0;       ///< 线的宽度
const CGFloat kZDRulerShortLineLength  = 8;  ///< 短线的长度
const CGFloat kZDRulerMediumLineLength = 16; ///< 中长的线的长度
const CGFloat kZDRulerLongLineLength  = 32;  ///< 长线的长度
const CGFloat kZDRulerLineOffsetY  = 3;      ///< 线的垂直方向起始偏移量
const CGFloat kZDRulerTextBottomOffset = 20; ///< 文字底部偏移量(包括了文字高度)
NSString *const kZDRulerUnit = @"m";       ///< 单位


@interface RulerItem : UIView

/// 0 leading 第一个, 1 normal 中间的, 2, trailing 最后一个
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) BOOL      isNeedShowMediumLine;

@property (assign, nonatomic) NSInteger     intervalStepNum;
@property (assign, nonatomic) CGFloat       maxValue;
@property (assign, nonatomic) CGFloat       minValue;
@property (assign, nonatomic) CGFloat       step;
@property (assign, nonatomic) CGFloat       stepDotNum;

@end

@implementation RulerItem

- (void)drawRect:(CGRect)rect
{
    NSDictionary *attribute = @{NSFontAttributeName:kZDRulerTextFont, NSForegroundColorAttributeName:kZDRulerTextColor};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    for (NSInteger i = 0; i <= _intervalStepNum; i ++) {
        if (_type == 0) {
            NSString *value = [NSString stringWithFormat:@"%.f%@", _maxValue, kZDRulerUnit];
            CGFloat width = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:0 attributes:attribute context:nil].size.width;
            [value drawInRect:CGRectMake(rect.size.width - width*0.5, rect.size.height - kZDRulerTextBottomOffset, width, 15) withAttributes:attribute];
            
            CGContextMoveToPoint(context, rect.size.width, kZDRulerLineOffsetY);
            CGContextSetStrokeColorWithColor(context, kZDRulerLongLineColor.CGColor);
            CGContextAddLineToPoint(context, rect.size.width, kZDRulerLineOffsetY + kZDRulerLongLineLength);
            CGContextStrokePath(context);
            break;
        }
        else if (_type == 2) {
            NSString *value = [NSString stringWithFormat:@"%.f%@", _minValue, kZDRulerUnit];
            CGFloat width = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:0 attributes:attribute context:nil].size.width;
            [value drawInRect:CGRectMake(0 - width*0.5, rect.size.height - kZDRulerTextBottomOffset, width, 15) withAttributes:attribute];
            
            CGContextMoveToPoint(context, 0, kZDRulerLineOffsetY);
            CGContextSetStrokeColorWithColor(context, kZDRulerLongLineColor.CGColor);
            CGContextAddLineToPoint(context, 0, kZDRulerLineOffsetY + kZDRulerLongLineLength);
            CGContextStrokePath(context);
            break;
        }
        else {
            CGFloat x = _stepDotNum * i;
            CGContextMoveToPoint(context, x, kZDRulerLineOffsetY);
            if (i%_intervalStepNum == 0) {
                // 长线
                CGContextSetStrokeColorWithColor(context, kZDRulerLongLineColor.CGColor);
                CGContextAddLineToPoint(context, x, kZDRulerLineOffsetY + kZDRulerLongLineLength);
                CGContextStrokePath(context);
                // 文本
                NSString *value = [NSString stringWithFormat:@"%.f%@", i*_step + _minValue, kZDRulerUnit];
                CGFloat width = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:0 attributes:attribute context:nil].size.width;
                [value drawInRect:CGRectMake(x - width*0.5, rect.size.height - kZDRulerTextBottomOffset, width, 15) withAttributes:attribute];
            }
            else if (_isNeedShowMediumLine && i % (_intervalStepNum/2) == 0) {
                // 中长的线
                CGContextSetStrokeColorWithColor(context, kZDRulerMediumLineColor.CGColor);
                CGContextAddLineToPoint(context, x, kZDRulerLineOffsetY + kZDRulerMediumLineLength);
                CGContextStrokePath(context);
            }
            else {
                // 短线
                CGContextSetStrokeColorWithColor(context, kZDRulerShortLineColor.CGColor);
                CGContextAddLineToPoint(context, x, kZDRulerLineOffsetY + kZDRulerShortLineLength);
                CGContextStrokePath(context);
            }
        }
    }
}

@end

/**
 RulerCollectionView已废弃，另外有更好的解决办法
 
 解决：在减速时轻触scrollView会使减速立即停止，在scrollViewWillBeginDragging中setContentOffse和在scrollViewDidEndDecelerating中设置contentOffset会冲突。
 如果不使用RulerCollectionView，在滑到尺子的两端时使劲滑会感觉到明显的闪动，因为setContentOffset的动画还没结束。
 但使用RulerCollectionView后有个缺点就是在减速时不能继续连贯滑动
 */
NS_UNAVAILABLE @interface RulerCollectionView : UICollectionView
@end

@implementation RulerCollectionView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isDecelerating) {
        [UIView animateWithDuration:0.0001 animations:^{
            [self setContentOffset:self.contentOffset];
        } completion:^(BOOL finished) {
            [self.delegate scrollViewDidEndDecelerating:self];
        }];
        return NO;
    }
    return YES;
}

@end

@implementation EGORulerView

//MARK:- ❤ Life Cycle ❤
- (void)layoutSubviews {
    _collectionView.frame = self.bounds;
}

//MARK:- ❤ Public Method ❤
- (BOOL)configWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue step:(CGFloat)step stepDotNum:(CGFloat)stepDotNum intervalStepNum:(NSInteger)intervalStepNum
{
    if (maxValue <= minValue) {
        NSLog(@"<EGORulerView>: the 'maxValue' can't equal to or less than the 'minValue'.");
        return NO;
    }
    if ([self truncatingRemainder:maxValue dividingBy:step] || [self truncatingRemainder:minValue dividingBy:step]) {
        NSLog(@"<EGORulerView>: the 'maxValue' and 'minValue' can only be an integer multiple of 'step'.");
        return NO;
    }
    if (step <= 0) {
        NSLog(@"<EGORulerView>: the 'step' can't equal to or less than 0.");
        return NO;
    }
    
    _maxValue = maxValue;
    _minValue = minValue;
    _maxRulerValue = ceil(maxValue/intervalStepNum/step) * intervalStepNum*step;
    _minRulerValue = floor(minValue/intervalStepNum/step) * intervalStepNum*step;
    _itemCount = round((_maxRulerValue - _minRulerValue)/step) / intervalStepNum;
    _step = step;
    _stepDotNum = stepDotNum;
    _intervalStepNum = intervalStepNum;
    if (_itemCount < 1) {
        _itemCount = 1;
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
    [self setCurrentValueWithoutCallBack:_minValue animated:NO];
    return YES;
}

- (void)setCurrentValueWithoutCallBack:(CGFloat)currentValue animated:(BOOL)animated
{
    _currentValue = [self adjustCurrentValue:currentValue];
    [_collectionView setContentOffset:CGPointMake([self calcContentOffsetWithValue:_currentValue], _collectionView.contentOffset.y) animated:animated];
}

- (void)setCurrentValue:(CGFloat)currentValue animated:(BOOL)animated
{
    [self setCurrentValueWithoutCallBack:currentValue animated:animated];
    if (_currentValue <= _maxValue && _currentValue >= _minValue && _selectValueBlock) {
        _selectValueBlock(_currentValue);
    }
}


//MARK:- ❤ Private Method ❤
- (CGFloat)adjustCurrentValue:(CGFloat)currentValue
{
    if (currentValue > _maxValue) {
        currentValue = _maxValue;
    }
    else if (currentValue < _minValue) {
        currentValue = _minValue;
    }
    return currentValue;
}

- (double)truncatingRemainder:(double)a dividingBy:(double)b
{
    double c = a / b;
    if (c < 0) {
        return a - ceil(c)*b;
    }
    else {
        return a - floor(c)*b;
    }
}

/// 根据滚动偏移量计算当前值
- (CGFloat)calcCurrentValueWithOffset:(CGFloat)offset {
    return round((offset+_collectionView.contentInset.left) / _stepDotNum) * _step + _minRulerValue;
}

/// 根据当前值计算滚动偏移量
- (CGFloat)calcContentOffsetWithValue:(CGFloat)value {
    return (NSInteger)((value - _minRulerValue)/_step) * _stepDotNum + _collectionView.contentInset.left;
}

//MARK:- ❤ Delegate ❤
//MARK: UICollectionViewDataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemCount + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    RulerItem *view = [cell.contentView viewWithTag:1];
    if (!view) {
        view = [[RulerItem alloc] initWithFrame:cell.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 1;
        [cell.contentView addSubview:view];
    }
    
    if (indexPath.row == 0) {
        // leading
        view.type = 0;
        view.maxValue = _minRulerValue;
        [view setFrame:CGRectMake(0, 0, collectionView.frame.size.width/2, collectionView.frame.size.height)];
    }
    else if (indexPath.row == _itemCount + 1) {
        // trailing
        view.type = 2;
        view.minValue = _maxRulerValue;
        [view setFrame:CGRectMake(0, 0, collectionView.frame.size.width/2, collectionView.frame.size.height)];
    }
    else {
        // normal ruler cell
        view.type = 1;
        view.minValue = _step * (indexPath.row-1) * _intervalStepNum + _minRulerValue;
        [view setFrame:CGRectMake(0, 0, _stepDotNum * _intervalStepNum, collectionView.frame.size.height)];
    }
    
    view.stepDotNum = _stepDotNum;
    view.step = _step;
    view.intervalStepNum = _intervalStepNum;
    view.isNeedShowMediumLine = _intervalStepNum%2 == 0;
    [view setNeedsDisplay];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == _itemCount + 1) {
        return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height);
    }
    else {
        return CGSizeMake(_stepDotNum * _intervalStepNum, collectionView.frame.size.height);
    }
}

// 滑动到指定的刻度位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint target = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    //CGFloat offset = round((target.x+scrollView.contentInset.left) / self.stepDotNum) * self.stepDotNum;
    CGFloat currentValue = [self adjustCurrentValue:[self calcCurrentValueWithOffset:target.x]];
    CGFloat offset = [self calcContentOffsetWithValue:currentValue];
    *targetContentOffset = CGPointMake(offset, target.y);
}

// 实现上面的方法可以不用考虑下面三个方法的处理
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        // 释放拖动并没有减速动画时
//        //[self setCurrentValue:round((scrollView.contentOffset.x+scrollView.contentInset.left) / _stepDotNum) + _minRulerValue animated:YES];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //[self setCurrentValue:round((scrollView.contentOffset.x+scrollView.contentInset.left) / _stepDotNum) + self.minRulerValue animated:YES];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    // 在滑到尺子的两端时使劲滑会感觉到明显的闪动，因为scrollViewDidEndDecelerating方法setContentOffset的动画还没结束。
////    if (scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width || scrollView.contentOffset.x < 0) {
////        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
////    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentValue = [self adjustCurrentValue:[self calcCurrentValueWithOffset:scrollView.contentOffset.x]];
    if (_selectValueBlock) {
        _selectValueBlock(_currentValue);
    }
}

//MARK:- ❤ Getter & Setter ❤
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = YES;
        _collectionView.delaysContentTouches = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

@end
