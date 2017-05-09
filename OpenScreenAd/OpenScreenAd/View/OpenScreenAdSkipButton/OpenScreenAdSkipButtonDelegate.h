//
//  OpenScreenAdSkipButtonDelegate.h
//  Pods
//
//  Created by wyan assert on 2017/4/20.
//
//

#import <Foundation/Foundation.h>

@protocol OpenScreenAdSkipButtonDelegate <NSObject>

- (void)userDidSelectOpenScreenSkipButton:(NSUInteger)countdown;

- (void)openScreenSkipButtonDidCompleteCountdown;
- (void)openScreenSkipButtonSkipEnaled;

@end
