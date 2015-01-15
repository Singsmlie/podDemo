//
//  YFNewsUINotificationWindow.m
//  YFNewsUI
//
//  Created by kevin on 14/11/8.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "YFNewsUINotificationWindow.h"

typedef void(^YFNewsUINotificationWindowBlock)(void);

@interface YFNewsUINotificationWindow ()
{
    UIButton *decaleButton;//忽略
    UIButton *lookButton;//立即观看
    
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

@property (nonatomic,copy) YFNewsUINotificationWindowBlock actionBlock;

@property (nonatomic,copy) YFNewsUINotificationWindowBlock decaleBlock;

@property (nonatomic,copy) YFNewsUINotificationWindowBlock completeBlock;

@end

@implementation YFNewsUINotificationWindow


#pragma mark
#pragma mark Singlenton Method
//Singlenton 这里必须要实现autorelease 方法
+ (YFNewsUINotificationWindow *)Instance
{
    static dispatch_once_t pred = 0;
    __strong static YFNewsUINotificationWindow *_shareObject = nil;
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

- (void)show:(NSString *)title action:(void(^)(void))action decale:(void(^)(void))decale complete:(void(^)(void))complete OrientationLeft:(BOOL)OrientationLeft
{
    
    [self show];
    
    self.actionBlock = action;
    
    self.decaleBlock = decale;
    
    self.completeBlock = complete;
    
    [self.titleLabel setText:title];
    
    if (self.cancelTitle) {
        [decaleButton setTitle:self.cancelTitle forState:UIControlStateNormal];
    }
    
    if (self.certTitle) {
        [lookButton setTitle:self.certTitle forState:UIControlStateNormal];
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
        self.cancelTitle = nil;
        self.certTitle = nil;
        [decaleButton setTitle:@"忽略" forState:UIControlStateNormal];
        [lookButton setTitle:@"立即观看" forState:UIControlStateNormal];
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
    self.maskView.alpha = 0.7;
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
    [self.contentView setAlpha:0.9f];
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
    //title
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:22]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:18]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-18]];
    
    
    self.wspeline = [self spelineLine];
    [self.contentView addSubview:self.wspeline];
    //
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:22]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_wspeline attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    
    decaleButton = [self buttonWithTitle:@"忽略"];
    [decaleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:decaleButton];
    
    self.lspeline = [self spelineLine];
    [self.contentView addSubview:self.lspeline];
    
    lookButton = [self buttonWithTitle:@"立即观看"];
    [lookButton setTitleColor:YFUIKit_RGB(223, 48, 49) forState:UIControlStateNormal];
    [lookButton setTitleColor:YFUIKit_RGB(223, 48, 49) forState:UIControlStateHighlighted];
    lookButton.layer.borderWidth = 0.0f;
    [lookButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:lookButton];
    
    
    //添加约束  top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:decaleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_wspeline attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //left
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:decaleButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    //height
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:decaleButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    
    //width
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:decaleButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0]];
    
    //line
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lspeline attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_wspeline attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lspeline attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:decaleButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lspeline attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lspeline attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];


    //添加约束  满屏幕
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lookButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_wspeline attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lookButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lspeline attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lookButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lookButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    
    
    contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lookButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:contentHeightConstraint];
    
}

- (void)buttonClick:(id)sender
{
    [self dismiss];
    if(sender == lookButton){
        if (self.actionBlock) {
            self.actionBlock();
        }
    }else if (sender == decaleButton){
        if (self.decaleBlock) {
            self.decaleBlock();
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
    //[label setBackgroundColor:[UIColor orangeColor]];
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
    //[button setBackgroundColor:[UIColor whiteColor]];
//    [button.layer setCornerRadius:2.5f];
//    [button.layer setBorderWidth:1.0f];
//    [button.layer setBorderColor:YFNEWS_COL999999.CGColor];
    //button.showsTouchWhenHighlighted = YES;
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
