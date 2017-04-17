//
//  OpenScreenAdSkipButton.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenScreenAdSkipButtonDelegate <NSObject>

- (void)userDidSelectOpenScreenSkipButton:(NSUInteger)countdown;

- (void)openScreenSkipButtonDidCompleteCountdown;
- (void)openScreenSkipButtonSkipEnaled;

@end

@interface OpenScreenAdSkipButton : UIView

- (void)startCountdown;

- (NSUInteger)getRunSecond;

@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;
@property (nonatomic, assign) NSUInteger delaySecond;

@property (nonatomic, strong) id<OpenScreenAdSkipButtonDelegate> delegate;

@end
