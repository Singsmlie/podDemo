//
//  YFNewsSimpleAlert.h
//  YFNewsUI
//
//  Created by kevin on 14/12/1.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFNewsSimpleAlert : UIWindow

+ (YFNewsSimpleAlert *)Instance;

- (void)show:(NSString *)title buttonTitle:(NSString *)buttonTitle action:(void(^)(void))action complete:(void(^)(void))complete OrientationLeft:(BOOL)OrientationLeft;
- (void)dismiss;

@end
