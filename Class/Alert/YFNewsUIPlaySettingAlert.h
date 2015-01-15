//
//  YFNewsUIPlaySettingAlert.h
//  YFNewsUI
//
//  Created by kevin on 14/11/6.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YFNewsPlaySettingButtonTheme.h"

typedef enum : NSUInteger {
    YFNewsUISettingAlertTypeCheckNoWifi,//wifi 变更
    YFNewsUISettingAlertTypeAutoPlay,//自动播放设置
    YFNewsUISettingAlertTypePushNotification,//推送通知
} YFNewsUISettingAlertType;

@protocol YFNewsUIPlaySettingAlertDelegate;

@interface YFNewsUIPlaySettingAlert : UIWindow

@property (nonatomic, assign) YFNewsUISettingAlertType alertType;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, copy) NSString *destructiveButtonTitle;

@property (nonatomic, strong) YFNewsPlaySettingButtonTheme *theme;

@property (nonatomic, weak) id<YFNewsUIPlaySettingAlertDelegate>alertdelegate;

+ (YFNewsUIPlaySettingAlert *)Instance;

- (void)show:(YFNewsUISettingAlertType)type title:(NSString *)title;
//- (void)show:(YFNewsUISettingAlertType)type title:(NSString *)title OrientationLeft:(BOOL)OrientationLeft;
- (void)show;
- (void)dismiss;
- (void)dismiss:(BOOL)animated afterDelay:(NSTimeInterval)delay;
- (void)dismiss:(YFNewsUISettingAlertType)changeType title:(NSString *)title afterDelay:(NSTimeInterval)delay finish:(dispatch_block_t)callback;


@end

@protocol YFNewsUIPlaySettingAlertDelegate <NSObject>

@optional
- (void)YFNewsUIPlaySettingAlertDidClickButtonAtIndex:(YFNewsUIPlaySettingAlert *)alert index:(NSInteger)index;
- (void)YFNewsUIPlaySettingAlertWillPresent:(YFNewsUIPlaySettingAlert *)alert;
- (void)YFNewsUIPlaySettingAlertDidPresent:(YFNewsUIPlaySettingAlert *)alert;
- (void)YFNewsUIPlaySettingAlert:(YFNewsUIPlaySettingAlert *)alert willDismissWithButtonTitle:(NSString *)title;
- (void)YFNewsUIPlaySettingAlert:(YFNewsUIPlaySettingAlert *)alert didDismissWithButtonTitle:(NSString *)title;
@end
