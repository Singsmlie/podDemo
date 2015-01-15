//
//  YFNewsUIFreeStreamAlert.m
//  YFNewsUI
//
//  Created by kevin on 14/11/26.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "YFNewsUIFreeStreamAlert.h"


@interface YFNewsUIFreeStreamAlert ()
{
    UIView *_maskView;
    UILabel *_titleLabel;
}

@end

@implementation YFNewsUIFreeStreamAlert

#pragma mark
#pragma mark Singlenton Method
//Singlenton 这里必须要实现autorelease 方法
+ (YFNewsUIFreeStreamAlert *)Instance
{
    static dispatch_once_t pred = 0;
    __strong static YFNewsUIFreeStreamAlert *_shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[self alloc]init];
    });
    return _shareObject;
}

+ (YFNewsUIFreeStreamAlert *)factory
{
    return [[YFNewsUIFreeStreamAlert alloc]init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [self setFrame:CGRectMake((CGRectGetWidth(rect)-370/2)/2, 410/2, 370/2, 150/2)];

    //mask view
    _maskView = [[UIView alloc]init];
    [_maskView setBackgroundColor:[UIColor blackColor]];
    [_maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _maskView.alpha = 0.7;
    _maskView.layer.cornerRadius = 2.5f;
    [self addSubview:_maskView];
    
    //添加约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:370/2]];
    [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150/2]];

    _titleLabel = [[UILabel alloc]init];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:_titleLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [_titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:280/2]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)showWithMessage:(NSString *)msg
{
    [_titleLabel setText:msg];
    [self show];
}

- (void)showWithMessage:(NSString *)msg afterDelay:(NSTimeInterval)delay OrientationLeft:(BOOL)OrientationLeft
{
    CGRect rect = [UIScreen mainScreen].bounds;
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    //全屏时候旋转 修改约束条件
    if (OrientationLeft) {
        //CGFloat topOffSety = (CGRectGetHeight(rect) - CGRectGetWidth(rect) + (CGRectGetWidth(rect) - 150/2)/2);
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
            
        {
            // 8.0 系统的适配处理。
            [self setCenter:CGPointMake(self.center.x, self.center.y+50)];
        }else{

        }
        //NSLog(@"topOffSety %f", topOffSety);

        //[self setFrame:CGRectMake((CGRectGetWidth(rect)-370/2)/2, topOffSety, 370/2, 150/2)];
        
        NSLog(@"%@", NSStringFromCGRect(self.frame));
        
        [self setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        
        //NSLog(@"%@  %@",NSStringFromCGPoint(self.layer.anchorPoint), NSStringFromCGRect(rect));
        
    }else{
        [self setFrame:CGRectMake((CGRectGetWidth(rect)-370/2)/2, 410/2, 370/2, 150/2)];
        [self setTransform:CGAffineTransformIdentity];
    }
    [self showWithMessage:msg];
    [self updateConstraints];
    [self setNeedsDisplay];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self setTransform:CGAffineTransformIdentity];
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
    return;
    UITouch * touch = [[event allTouches] anyObject];
    if (touch.view == self.maskView) {
        // Try to dismiss if backgroundTouch flag set.
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
