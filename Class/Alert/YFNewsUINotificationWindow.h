//
//  YFNewsUINotificationWindow.h
//  YFNewsUI
//
//  Created by kevin on 14/11/8.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFNewsUINotificationWindow : UIWindow

+ (YFNewsUINotificationWindow *)Instance;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) NSString *certTitle;

- (void)show:(NSString *)title action:(void(^)(void))action decale:(void(^)(void))decale complete:(void(^)(void))complete OrientationLeft:(BOOL)OrientationLeft;
- (void)dismiss;
- (void)setUpPopView;
@end
