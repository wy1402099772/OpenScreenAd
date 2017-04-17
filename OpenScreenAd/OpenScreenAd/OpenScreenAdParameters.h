//
//  OpenScreenAdParameters.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OSA_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define OSA_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define OSA_SCREENAPPLYSPACE(x) OSA_SCREEN_WIDTH / 375.0 * (x)
#define OSA_SCREENAPPLYHEIGHT(x) OSA_SCREEN_HEIGHT / 667.0 * (x)

#define OSA_RESOUCE_BUNDLE [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"OpenScreenAd" ofType:@"bundle"]]

static NSUInteger kOSASkipButtonSize = 40;
static NSUInteger kOSASkipCircleWidth = 3;

static NSUInteger kOSASkipSecond = 3;
static NSUInteger kOSATotalSecond = 5;
static NSUInteger kOSAWaitSecond = 3;
static NSUInteger kOSADelaySecond = 1;

@interface OpenScreenAdParameters : NSObject

@end
