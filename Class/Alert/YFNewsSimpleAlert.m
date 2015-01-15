//
//  YFNewsSimpleAlert.m
//  YFNewsUI
//
//  Created by kevin on 14/12/1.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "YFNewsSimpleAlert.h"

typedef void(^YFNewsSimpleAlertBlock)(void);

@interface YFNewsSimpleAlert ()
{
    UIButton *certButton;//我知道了
    
    NSLayoutConstraint *contentHeightConstraint;
    
    NSLayoutConstraint *contentTopConstraint;
}

@property (nonatomic, strong)   UIView *maskView;
@property (nonatomic, strong)   UIView *contentView;
@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, strong)   UILabel *wspeline;//横向line
@property (nonatomic, strong)   UILabel *lspeline;//竖向line

@property (nonatomic, weak)     UIWindow *applicationKeyWindow;
@property (nonatomic, assign)   BOOL isShowing;

@property (nonatomic,copy) YFNewsSimpleAlertBlock actionBlock;

@property (nonatomic,copy) YFNewsSimpleAlertBlock decaleBlock;

@property (nonatomic,copy) YFNewsSimpleAlertBlock completeBlock;

@end

@implementation YFNewsSimpleAlert

#pragma mark
#pragma mark Singlenton Method
//Singlenton 这里必须要实现autorelease 方法
+ (YFNewsSimpleAlert *)Instance
{
    static dispatch_once_t pred = 0;
    __strong static YFNewsSimpleAlert *_shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[self alloc]init];
    });
    return _shareObject;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        self.windowLevel = UIWindowLevelAlert;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setUpPopView];
    }
    return self;
}

- (void)show:(NSString *)title buttonTitle:(NSString *)buttonTitle action:(void(^)(void))action complete:(void(^)(void))complete OrientationLeft:(BOOL)OrientationLeft
{
    
    [self show];
    
    self.actionBlock = action;
    
    self.completeBlock = complete;
    
    [self.titleLabel setText:title];
    
    if (buttonTitle && buttonTitle.length > 0) {
        [certButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
    CGRect rect = [UIScreen mainScreen].bounds;
    //全屏时候旋转 修改约束条件
    if (OrientationLeft) {
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height)];
        [self removeConstraint:contentTopConstraint];
        CGFloat topOffSety = (CGRectGetHeight(rect) - CGRectGetWidth(rect) + (CGRectGetWidth(rect) - 140)/2);
        contentTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:topOffSety];
        [self addConstraint:contentTopConstraint];
        [self setTransform:[self getTransformMakeRotationByOrientation:UIInterfaceOrientationLandscapeLeft]];
        
    }else{
        [self setFrame:[UIScreen mainScreen].bounds];
        [self removeConstraint:contentTopConstraint];
        contentTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:200];
        [self addConstraint:contentTopConstraint];
        [self setTransform:CGAffineTransformIdentity];
    }
    
    [self updateConstraints];
    
    [self setNeedsDisplay];
    
    
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self setTransform:CGAffineTransformIdentity];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    
}

- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    
}

- (void)show
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.alpha = 0;
    [self setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
}

- (void)setUpPopView
{
    
    //mask view
    self.maskView = [[UIView alloc]init];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.maskView.alpha = 0.5;
    [self addSubview:self.maskView];
    
    //添加约束  满屏幕
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    self.contentView = [[UIView alloc]init];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5.0f;
    [self.contentView setAlpha:0.95f];
    [self addSubview:self.contentView];
    
    //添加约束
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:250]];
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:33]];
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-33]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    contentTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:200];
    [self addConstraint:contentTopConstraint];
    
    self.titleLabel = [self multilineLabelWithAttributedString:@"标题"];
    [self.contentView addSubview:_titleLabel];
    //
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:22]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:35]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-35]];
    
    
    self.wspeline = [self spelineLine];
    [self.contentView addSubview:self.wspeline];
    //
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:22]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    
    //YFNEWS_COLDF3031
    certButton = [self buttonWithTitle:@"我知道了"];
    [certButton setTitleColor:YFUIKit_RGB(223, 48, 49) forState:UIControlStateNormal];
    certButton.layer.borderWidth = 0.0f;
    [certButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:certButton];
    
    
    //添加约束  满屏幕
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:certButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_wspeline attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:certButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:certButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:certButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];

    
    
    contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:certButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:contentHeightConstraint];
    
}

- (void)buttonClick:(id)sender
{
    [self dismiss];
    if(sender == certButton){
        if (self.actionBlock) {
            self.actionBlock();
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [[event allTouches] anyObject];
    if (touch.view == self.maskView) {
        // Try to dismiss if backgroundTouch flag set.
        //[self dismiss];
    }
}

#pragma mark - Factories

- (UILabel *)multilineLabelWithAttributedString:(NSString *)attributedString {
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setText:attributedString];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setTextColor:YFUIKit_RGB(51, 51, 51)];
    return label;
}

- (UIImageView *)centeredImageViewForImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return imageView;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:YFUIKit_RGB(102, 102, 102) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [button setAlpha:0.9f];
    return button;
}

- (UILabel *)spelineLine
{
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setBackgroundColor:YFUIKit_RGB(219, 219, 219)];
    return label;
}


- (CGAffineTransform)getTransformMakeRotationByOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return CGAffineTransformMakeRotation(-M_PI);
    }
    else
    {
        
    }
    return CGAffineTransformIdentity;
}


@end
