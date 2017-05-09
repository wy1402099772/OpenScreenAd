//
//  OpenScreenAdParameters.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OpenScreenAdViewController.h"

#define OSA_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define OSA_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define OSA_SCREENAPPLYSPACE(x) OSA_SCREEN_WIDTH / 375.0 * (x)
#define OSA_SCREENAPPLYHEIGHT(x) OSA_SCREEN_HEIGHT / 667.0 * (x)

#define OSA_RESOUCE_BUNDLE [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LaunchAd" ofType:@"bundle"]]

#define OSA_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define OSA_UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define OSA_UIColorFromRGB(r,g,b)               OSA_UIColorFromRGBA(r,g,b,1.0)

static NSUInteger kOSASkipButtonSize = 40;
static NSUInteger kOSASkipCircleWidth = 2;

static NSUInteger kOSASkipSecond = 2;
static NSUInteger kOSATotalSecond = 5;
static NSUInteger kOSAWaitSecond = 5;
static NSUInteger kOSADelaySecond = 3;

@interface OpenScreenAdParameters : NSObject

+ (UIFont*)getFontRegular:(CGFloat)fontSize;
+ (UIFont*)getFontHeavy:(CGFloat)fontSize;
+ (UIFont *)getFontLight:(CGFloat)fontSize;

+ (NSString *)getLaunchImageName;

+ (CGRect)getAdFrame:(OpenScreenAdType)adType;
+ (CGRect)getSkipButtonFrame:(OpenScreenAdType)adType;

@end
