//
//  Define.h
//  LightDemo
//
//  Created by user on 2018/11/14.
//  Copyright © 2018年 adu. All rights reserved.
//

#ifndef Define_h
#define Define_h

// 在release版本中关闭NSLog打印
#ifdef DEBUG
#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define NSLog(format, ...)
#endif

//屏幕宽高
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define Width           self.view.frame.size.width
#define Height          self.view.frame.size.height

/**
 比例以宽来计算
 总共三种尺寸，320， 375， 414
 */
#define Suit414Width           1.104
#define Suit320Width            1.171875

// 系统判定
#define IOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS8        (IOS_VERSION >= 8.0 && IOS_VERSION < 9.0)
#define IS_IOS9        (IOS_VERSION >= 9.0 && IOS_VERSION < 10.0)
#define IS_IOS10       (IOS_VERSION >= 10.0 && IOS_VERSION < 11.0)
#define IS_IOS11       (IOS_VERSION >= 11.0 && IOS_VERSION < 12.0)
#define IS_IOS12       (IOS_VERSION >= 12.0)

// 屏幕判定（最低5）
#define IS_IPHONE4INCH  (ScreenHeight == 568 ? YES : NO)//5，se
#define IS_IPHONE47INCH  (ScreenHeight == 667 ? YES : NO)//6, 7，8
#define IS_IPHONE55INCH (ScreenHeight == 736 ? YES : NO)//6,7,8 plus
#define IS_IPHONE58INCH (ScreenHeight == 812 ? YES : NO)//x, xs
#define IS_IPHONE6INCH (ScreenHeight == 896 ? YES : NO)//xr, xs max

//屏宽320
#define IS_WIDTH320     (IS_IPHONE4INCH ? YES : NO)
//屏宽375
#define IS_WIDTH375     ((IS_IPHONE47INCH || IS_IPHONE58INCH) ? YES : NO)
//屏宽414
#define IS_WIDTH414     ((IS_IPHONE55INCH || IS_IPHONE6INCH) ? YES : NO)

// naviBar, statusBar, tabBar
#define IS_SPECIALHEIGHTBAR        ((IS_IPHONE58INCH || IS_IPHONE6INCH) ? YES : NO)
#define HEIGHT_STATUSBAR            (IS_SPECIALHEIGHTBAR ? 44 : 20)
#define HEIGHT_TABBAR               (IS_SPECIALHEIGHTBAR ? 83 : 49)
#define HEIGHT_NAVBAR               (IS_SPECIALHEIGHTBAR ? 88 : 64)

#endif /* Define_h */
