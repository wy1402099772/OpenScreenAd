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

static NSUInteger kOSASkipButtonSize = 40;
static NSUInteger kOSASkipCircleWidth = 3;

static NSUInteger kOSASkipSecond = 3;
static NSUInteger kOSATotalSecond = 5;

@interface OpenScreenAdParameters : NSObject

@end
