//
//  OpenScreenAdSkipButtonProtocol.h
//  Pods
//
//  Created by wyan assert on 2017/4/20.
//
//

#import <Foundation/Foundation.h>

@protocol OpenScreenAdSkipButtonDelegate;

@protocol OpenScreenAdSkipButtonProtocol <NSObject>

- (void)startCountdown;
- (void)forceToCountDown;

- (NSUInteger)getRunSecond;

- (void)setAllowSkipSecond:(NSUInteger)allowSkipSecond;
- (void)setTotalSecond:(NSUInteger)totalSecond;
- (void)setDelaySecond:(NSUInteger)delaySecond;

- (void)setDelegate:(id<OpenScreenAdSkipButtonDelegate>)delegate;

@end
