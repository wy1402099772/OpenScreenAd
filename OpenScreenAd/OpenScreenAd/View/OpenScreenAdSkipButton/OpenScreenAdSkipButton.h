//
//  OpenScreenAdSkipButton.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenScreenAdSkipButtonProtocol.h"

@protocol OpenScreenAdSkipButtonDelegate;

@interface OpenScreenAdSkipButton : UIView <OpenScreenAdSkipButtonProtocol>

@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;
@property (nonatomic, assign) NSUInteger delaySecond;

@property (nonatomic, strong) id<OpenScreenAdSkipButtonDelegate> delegate;

@end
