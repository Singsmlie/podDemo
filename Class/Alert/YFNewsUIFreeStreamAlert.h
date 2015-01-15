//
//  YFNewsUIFreeStreamAlert.h
//  YFNewsUI
//
//  Created by kevin on 14/11/26.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFNewsUIFreeStreamAlert : UIView

+ (YFNewsUIFreeStreamAlert *)Instance;
+ (YFNewsUIFreeStreamAlert *)factory;

- (void)show;

- (void)dismiss;

- (void)showWithMessage:(NSString *)msg;

- (void)showWithMessage:(NSString *)msg afterDelay:(NSTimeInterval)delay OrientationLeft:(BOOL)OrientationLeft;

@end
