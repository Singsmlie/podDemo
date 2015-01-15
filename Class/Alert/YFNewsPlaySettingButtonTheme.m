//
//  YFNewsPlaySettingButtonTheme.m
//  YFNewsUI
//
//  Created by kevin on 14/11/6.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "YFNewsPlaySettingButtonTheme.h"

@implementation YFNewsPlaySettingButtonTheme

+ (YFNewsPlaySettingButtonTheme *)defaultTheme {
    YFNewsPlaySettingButtonTheme *defaultTheme = [[YFNewsPlaySettingButtonTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 6.0f;
    defaultTheme.buttonBackgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    defaultTheme.destructiveButtonBackgroundColor = [UIColor darkGrayColor];
    defaultTheme.buttonHeight = 44.0f;
    defaultTheme.buttonCornerRadius = 6.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
    defaultTheme.popupStyle = YFNewsPlaySettingPopStyleTwo;
    defaultTheme.presentationStyle = YFNewsPlaySettingPresentationStyleSlideInFromBottom;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = YFNewsPlaySettingMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = YES;
    defaultTheme.contentVerticalPadding = 12.0f;
    return defaultTheme;
}


@end
