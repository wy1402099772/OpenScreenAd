//
//  OpenScreenAdParameters.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define OSA_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define OSA_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define OSA_SCREENAPPLYSPACE(x) OSA_SCREEN_WIDTH / 375.0 * (x)
#define OSA_SCREENAPPLYHEIGHT(x) OSA_SCREEN_HEIGHT / 667.0 * (x)

#define OSA_RESOUCE_BUNDLE [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LaunchAd" ofType:@"bundle"]]

#define OSA_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSUInteger kOSASkipButtonSize = 40;
static NSUInteger kOSASkipCircleWidth = 2;

static NSUInteger kOSASkipSecond = 2;
static NSUInteger kOSATotalSecond = 5;
static NSUInteger kOSAWaitSecond = 3;
static NSUInteger kOSADelaySecond = 1;

@interface OpenScreenAdParameters : NSObject

+ (UIFont*)getFontRegular:(CGFloat)fontSize;
+ (UIFont*)getFontHeavy:(CGFloat)fontSize;
+ (UIFont *)getFontLight:(CGFloat)fontSize;

@end
