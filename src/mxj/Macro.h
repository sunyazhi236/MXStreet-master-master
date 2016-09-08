//
//  Macro.h
//  mxj
//
//  Created by MQ-MacBook on 16/5/12.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#endif

#define SCREEN_IPHONE5    (([[UIScreen mainScreen] bounds].size.height) >= 568)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IS_IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)

#define SYSTEM_MAIN_VERSION_7 (7)
//自定义导航条高度：可扩充
#define STATUSBAR_HIGHT  (20)
#define NAVBAR_HIGHTIOS_7 (44 + 20)
//#define kNavBarDefaultHeight  (44)
#define NAVBAR_DEFAULT_HEIGHT  ((IS_IOS7) ? (NAVBAR_HIGHTIOS_7) : (44))
#define STATUSBAR_DEFAULT_HEIGHT  ((IS_IOS7) ? (0) : (STATUSBAR_HIGHT))

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define NAVBAR_HIGHT self.navigationController.navigationBar.frame.size.height
#define TABBAR_HEIGHT self.tabBarController.tabBar.frame.size.height

#define MainViewHeight SCREENHEIGHT - NAVBAR_DEFAULT_HEIGHT - STATUSBAR_DEFAULT_HEIGHT
#define MainViewWidth  SCREENWIDTH

//keyboard:
#define NORMAL_KEYBOARD_HEIGHT 216.0f

// Color
#define RGBACOLOR(r, g, b, a)  [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha: (a)]
#define RGBCOLOR(r, g, b)     RGBACOLOR(r, g, b, 1)
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end