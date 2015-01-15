//
//  YFNewsPlaySettingButtonTheme.h
//  YFNewsUI
//
//  Created by kevin on 14/11/6.
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YFNewsPlaySettingPopStyle) {
    YFNewsPlaySettingPopStyleTwo = 0,
    YFNewsPlaySettingPopStyleThree,
};

// CNPPopupPresentationStyle: Controls how the popup is presented
typedef NS_ENUM(NSInteger, YFNewsPlaySettingPresentationStyle) {
    YFNewsPlaySettingPresentationStyleFadeIn = 0,
    YFNewsPlaySettingPresentationStyleSlideInFromTop,
    YFNewsPlaySettingPresentationStyleSlideInFromBottom,
    YFNewsPlaySettingPresentationStyleSlideInFromLeft,
    YFNewsPlaySettingPresentationStyleSlideInFromRight
};

// CNPPopupMaskType
typedef NS_ENUM(NSInteger, YFNewsPlaySettingMaskType) {
    YFNewsPlaySettingMaskTypeNone = 0,
    YFNewsPlaySettingMaskTypeClear,
    YFNewsPlaySettingMaskTypeDimmed,
};


@interface YFNewsPlaySettingButtonTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor; // Background color of the popup content view (Default white)
@property (nonatomic, assign) CGFloat cornerRadius; // Corner radius of the popup content view (Default 6.0)
@property (nonatomic, strong) UIColor *buttonBackgroundColor; // Background color of the content buttons (Default gray)
@property (nonatomic, strong) UIColor *destructiveButtonBackgroundColor; // Background color of the destructive button at the bottom of the popup (Default light gray)
@property (nonatomic, assign) CGFloat buttonHeight; // Height of the action buttons (Default 44.0f)
@property (nonatomic, assign) CGFloat buttonCornerRadius; // Corner radius of the action buttons (Default 6.0f)
@property (nonatomic, assign) UIEdgeInsets popupContentInsets; // Inset of labels, images and buttons on the popup content view (Default 16.0 on all sides)
@property (nonatomic, assign) YFNewsPlaySettingPopStyle popupStyle; // How the popup looks once presented (Default centered)
@property (nonatomic, assign) YFNewsPlaySettingPresentationStyle presentationStyle; // How the popup is presented (Defauly slide in from bottom)
@property (nonatomic, assign) BOOL dismissesOppositeDirection; // If presented from a direction, should it dismiss in the opposite? (Defaults to NO. i.e. Goes back the way it came in)
@property (nonatomic, assign) YFNewsPlaySettingMaskType maskType; // Backgound mask of the popup (Default dimmed)
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch; // Popup should dismiss on tapping on background mask (Default yes)
@property (nonatomic, assign) CGFloat contentVerticalPadding; // Spacing between each vertical element (Default 12.0)

// Factory method to help build a default theme
+ (YFNewsPlaySettingButtonTheme *)defaultTheme;


@end
