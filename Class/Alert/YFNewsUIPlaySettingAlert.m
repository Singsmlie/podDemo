//
//  YFNewsUIPlaySettingAlert.m
//  YFNewsUI
//
//  Created by kevin on 14/11/6.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "YFNewsUIPlaySettingAlert.h"

@interface YFNewsUIPlaySettingAlert ()
{
    UIButton *stopButton;
    UIButton *goOnButton;
    UIButton *imRichButton;
    
    NSLayoutConstraint *contentHeightConstraint;
}

@property (nonatomic, strong)   UIView *maskView;
@property (nonatomic, strong)   UIView *contentView;
@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, weak)     UIWindow *applicationKeyWindow;
@property (nonatomic, assign)   BOOL isShowing;

@end

@implementation YFNewsUIPlaySettingAlert

#pragma mark
#pragma mark Singlenton Method
//Singlenton 这里必须要实现autorelease 方法
+ (YFNewsUIPlaySettingAlert *)Instance
{
    static dispatch_once_t pred = 0;
    __strong static YFNewsUIPlaySettingAlert *_shareObject = nil;
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
        
        self.alertType = YFNewsUISettingAlertTypeCheckNoWifi;
        
        [self setUpPopView];
    }
    return self;
}

- (void)show:(YFNewsUISettingAlertType)type title:(NSString *)title
{
    self.alertType = type;
    [self show];
    
    [self removeConstraint:contentHeightConstraint];
    
    if (type == YFNewsUISettingAlertTypeCheckNoWifi) {
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imRichButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
        
        [stopButton setTitle:@"停止播放" forState:UIControlStateNormal];
        [stopButton setTitle:@"停止播放" forState:UIControlStateHighlighted];
        [goOnButton setTitle:@"继续播放" forState:UIControlStateNormal];
        [goOnButton setTitle:@"继续播放" forState:UIControlStateHighlighted];
        [stopButton setTitleColor:YFUIKit_RGB(220,50,55) forState:UIControlStateNormal];
        [imRichButton setTitleColor:YFUIKit_RGB(220,50,55) forState:UIControlStateNormal];
        
        [stopButton setTag:0];
        [goOnButton setTag:1];
        [imRichButton setTag:2];
        [imRichButton setHidden:NO];
        
        
    }else if (type == YFNewsUISettingAlertTypeAutoPlay){
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:stopButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
        
        [stopButton setTitle:@"自动播放" forState:UIControlStateNormal];
        [stopButton setTitle:@"自动播放" forState:UIControlStateHighlighted];
        [goOnButton setTitle:@"手动播放" forState:UIControlStateNormal];
        [goOnButton setTitle:@"手动播放" forState:UIControlStateHighlighted];
        [stopButton setTitleColor:YFUIKit_RGB(102, 102, 102) forState:UIControlStateNormal];
        
        [stopButton setTag:0];
        [goOnButton setTag:1];
        [imRichButton setHidden:YES];
        
        
    }else if(type == YFNewsUISettingAlertTypePushNotification){
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:107];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsDisplay];
}

- (void)show:(YFNewsUISettingAlertType)type title:(NSString *)title OrientationLeft:(BOOL)OrientationLeft
{
    //CGRect rect = [UIScreen mainScreen].bounds;
    if (OrientationLeft) {
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height-100, [UIScreen mainScreen].bounds.size.height)];
        [self setTransform:[self getTransformMakeRotationByOrientation:UIInterfaceOrientationLandscapeLeft]];
        
    }else{
        [self setFrame:[UIScreen mainScreen].bounds];
        [self setTransform:CGAffineTransformIdentity];

    }
    
    self.alertType = type;
    [self show];
    
    [self removeConstraint:contentHeightConstraint];
    
    if (type == YFNewsUISettingAlertTypeCheckNoWifi) {
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imRichButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
        
        [stopButton setTitle:@"停止播放" forState:UIControlStateNormal];
        [stopButton setTitle:@"停止播放" forState:UIControlStateHighlighted];
        [goOnButton setTitle:@"继续播放" forState:UIControlStateNormal];
        [goOnButton setTitle:@"继续播放" forState:UIControlStateHighlighted];
        [stopButton setTitleColor:YFUIKit_RGB(220,50,55) forState:UIControlStateNormal];
        [imRichButton setTitleColor:YFUIKit_RGB(220,50,55) forState:UIControlStateNormal];
        
        [stopButton setTag:0];
        [goOnButton setTag:1];
        [imRichButton setTag:2];
        [imRichButton setHidden:NO];
        
        
    }else if (type == YFNewsUISettingAlertTypeAutoPlay){
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:stopButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
        
        [stopButton setTitle:@"自动播放" forState:UIControlStateNormal];
        [stopButton setTitle:@"自动播放" forState:UIControlStateHighlighted];
        [goOnButton setTitle:@"手动播放" forState:UIControlStateNormal];
        [goOnButton setTitle:@"手动播放" forState:UIControlStateHighlighted];
        [stopButton setTitleColor:YFUIKit_RGB(102, 102, 102) forState:UIControlStateNormal];
        
        [stopButton setTag:0];
        [goOnButton setTag:1];
        [imRichButton setHidden:YES];
        
        
    }else if(type == YFNewsUISettingAlertTypePushNotification){
        contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:107];
        [self addConstraint:contentHeightConstraint];
        
        [self.titleLabel setText:title];
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsDisplay];

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


- (void)dismiss
{
    if (self.alertdelegate && [self.alertdelegate respondsToSelector:@selector(YFNewsUIPlaySettingAlert:willDismissWithButtonTitle:)]) {
        [self.alertdelegate YFNewsUIPlaySettingAlert:self willDismissWithButtonTitle:_titleLabel.text];
    }
    
    [self setHidden:YES];
    
    if (self.alertdelegate && [self.alertdelegate respondsToSelector:@selector(YFNewsUIPlaySettingAlert:didDismissWithButtonTitle:)]) {
        [self.alertdelegate YFNewsUIPlaySettingAlert:self didDismissWithButtonTitle:_titleLabel.text];
    }
}

- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    
}

- (void)dismiss:(YFNewsUISettingAlertType)changeType title:(NSString *)title afterDelay:(NSTimeInterval)delay finish:(dispatch_block_t)callback
{
    
}



- (void)show
{
    
    if (self.alertdelegate && [self.alertdelegate respondsToSelector:@selector(YFNewsUIPlaySettingAlertWillPresent:)]) {
        [self.alertdelegate YFNewsUIPlaySettingAlertWillPresent:self];
    }
    
    [self setHidden:NO];

    if (self.alertdelegate && [self.alertdelegate respondsToSelector:@selector(YFNewsUIPlaySettingAlertDidPresent:)]) {
        [self.alertdelegate YFNewsUIPlaySettingAlertDidPresent:self];
    }
    
}

- (void)setUpPopView
{
    //self.alpha = 1.0f;
    
    //mask view
    self.maskView = [[UIView alloc]init];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.maskView.alpha = 0.7;
    [self addSubview:self.maskView];
    
    //添加约束  满屏幕
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    self.contentView = [[UIView alloc]init];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5.0f;
    [self addSubview:self.contentView];
    
    contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:145];
    //添加约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:250]];
    [self addConstraint:contentHeightConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.titleLabel = [self multilineLabelWithAttributedString:@"标题"];
    [self.contentView addSubview:_titleLabel];
    //
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:19]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    
    stopButton = [self buttonWithTitle:@"停止播放"];
    [stopButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:stopButton];
    //添加约束  满屏幕
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:stopButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:14]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:stopButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:18]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:stopButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:34]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:stopButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:103]];
    
    goOnButton = [self buttonWithTitle:@"继续播放"];
    [goOnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goOnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [goOnButton setBackgroundColor:YFUIKit_RGB(220,50,55)];
    goOnButton.layer.borderWidth = 0.0f;
    [goOnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:goOnButton];
    //添加约束  满屏幕
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goOnButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:14]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goOnButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:stopButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:8]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goOnButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:34]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goOnButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:103]];
    
    imRichButton = [self buttonWithTitle:@"土豪无压力，以后都别烦我"];
    [imRichButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imRichButton];
    //添加约束  满屏幕
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imRichButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:stopButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:14]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imRichButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:18]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imRichButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-18]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imRichButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:34]];
    


}

- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.alertdelegate && [self.alertdelegate respondsToSelector:@selector(YFNewsUIPlaySettingAlertDidClickButtonAtIndex:index:)]) {
        [self.alertdelegate YFNewsUIPlaySettingAlertDidClickButtonAtIndex:self index:button.tag];
    }
    [self dismiss];
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
    [label setTextColor:YFUIKit_RGB(102, 102, 102)];
    return label;
}

- (UIImageView *)centeredImageViewForImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return imageView;
}

- (UIButton *)buttonWithAttributedTitle:(NSAttributedString *)attributedTitle {
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [button setBackgroundColor:self.theme.buttonBackgroundColor];
    [button.layer setCornerRadius:self.theme.buttonCornerRadius];
    return button;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:YFUIKit_RGB(102, 102, 102) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [button.layer setCornerRadius:2.5f];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:YFUIKit_RGB(153,153,153).CGColor];
    return button;
}

- (UIButton *)destructiveButtonWithAttributedTitle:(NSAttributedString *)attributedTitle {
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [button setBackgroundColor:self.theme.destructiveButtonBackgroundColor];
    return button;
}


@end
