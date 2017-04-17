//
//  OpenScreenAdSkipButton.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdSkipButton.h"
#import "OpenScreenAdCircleView.h"
#import "OpenScreenAdParameters.h"

@interface OpenScreenAdSkipButton ()

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) OpenScreenAdCircleView *circleView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval logInterval;
@property (nonatomic, assign) BOOL  isSkipEnabled;

@end

@implementation OpenScreenAdSkipButton

@synthesize allowSkipSecond = _allowSkipSecond;
@synthesize totalSecond = _totalSecond;

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}


#pragma mark - Public
- (void)startCountdown {
    [self performSelector:@selector(prepareToCountDown) withObject:nil afterDelay:self.delaySecond];
}

- (NSUInteger)getRunSecond {
    return [[NSDate date] timeIntervalSince1970] - self.logInterval;
}


#pragma mark - Private
- (void)configureView {
    self.hidden = YES;
    
    [self addSubview:self.circleView];
    [self addSubview:self.actionButton];
}

- (void)prepareToCountDown {
    self.hidden = NO;
    
    [self invalidateTimer];
    [self startTaskConfig];
}

- (void)startTaskConfig {
    self.isSkipEnabled = NO;
    self.logInterval = [[NSDate date] timeIntervalSince1970];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 / 30.0
                                                  target:self
                                                selector:@selector(triggleUIRefresh)
                                                userInfo:nil repeats:YES];
}

- (void)invalidateTimer {
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)didTrigleCanSkip {
    self.isSkipEnabled = YES;
    [self.actionButton setTitle:@"SKIP" forState:UIControlStateNormal];
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenSkipButtonSkipEnaled)]) {
        [self.delegate openScreenSkipButtonSkipEnaled];
    }
}

- (void)didRunOutCutDown {
    [self invalidateTimer];
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenSkipButtonDidCompleteCountdown)]) {
        [self.delegate openScreenSkipButtonDidCompleteCountdown];
    }
}

#pragma mark - Action
- (void)skipButtonDidSelectAction:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(userDidSelectOpenScreenSkipButton:)]) {
        [self.delegate userDidSelectOpenScreenSkipButton:0];
    }
}

- (void)triggleUIRefresh {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - self.logInterval;
    BOOL isCurrentSkipEnabled = interval > self.totalSecond - self.allowSkipSecond;
    if(interval > self.totalSecond) {
        [self didRunOutCutDown];
    } else if (!self.isSkipEnabled && isCurrentSkipEnabled) {
        [self didTrigleCanSkip];
    }
    self.circleView.progress = 1 - interval / self.totalSecond;
    self.actionButton.enabled = self.isSkipEnabled;
    
    if(!self.isSkipEnabled) {
        [self.actionButton setTitle:[NSString stringWithFormat:@"%lds", (long)(self.totalSecond - (int)interval)] forState:UIControlStateNormal];
    }
}


#pragma mark - Setter
- (void)setAllowSkipSecond:(NSUInteger)allowSkipSecond {
    _allowSkipSecond = allowSkipSecond;
}

- (void)setTotalSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
}


#pragma mark - Getter
- (UIButton *)actionButton {
    if(!_actionButton) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(kOSASkipCircleWidth, kOSASkipCircleWidth, kOSASkipButtonSize - 2 * kOSASkipCircleWidth, kOSASkipButtonSize - 2 * kOSASkipCircleWidth)];
        [_actionButton addTarget:self action:@selector(skipButtonDidSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
        _actionButton.layer.cornerRadius = (kOSASkipButtonSize - 2 * kOSASkipCircleWidth) / 2.0;
        _actionButton.layer.masksToBounds = YES;
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _actionButton;
}

- (OpenScreenAdCircleView *)circleView {
    if(!_circleView) {
        _circleView = [[OpenScreenAdCircleView alloc] initWithFrame:CGRectMake(0, 0, kOSASkipButtonSize, kOSASkipButtonSize)];
        _circleView.minNum = 0;
        _circleView.maxNum = 5;
        _circleView.progress = 1.0f;
        _circleView.enableCustom = NO;
        _circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
    }
    return _circleView;
}

- (NSUInteger)allowSkipSecond {
    if(!_allowSkipSecond) {
        _allowSkipSecond = kOSASkipSecond;
    }
    return _allowSkipSecond;
}

- (NSUInteger)totalSecond {
    if(!_totalSecond) {
        _totalSecond = kOSATotalSecond;
    }
    return _totalSecond;
}

- (NSUInteger)delaySecond {
    if(!_delaySecond) {
        _delaySecond = kOSADelaySecond;
    }
    return _delaySecond;
}

@end
