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

@end

@implementation OpenScreenAdSkipButton

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}


#pragma mark - Private
- (void)configureView {
    [self addSubview:self.circleView];
    [self addSubview:self.actionButton];
}


#pragma mark - Action
- (void)skipButtonDidSelectAction:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(userDidSelectOpenScreenSkipButton:)]) {
        [self.delegate userDidSelectOpenScreenSkipButton:0];
    }
}


#pragma mark - Getter
- (UIButton *)actionButton {
    if(!_actionButton) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(kOSASkipCircleWidth, kOSASkipCircleWidth, kOSASkipButtonSize - 2 * kOSASkipCircleWidth, kOSASkipButtonSize - 2 * kOSASkipCircleWidth)];
        [_actionButton addTarget:self action:@selector(skipButtonDidSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _actionButton.layer.cornerRadius = (kOSASkipButtonSize - 2 * kOSASkipCircleWidth) / 2.0;
        _actionButton.layer.masksToBounds = YES;
    }
    return _actionButton;
}

- (OpenScreenAdCircleView *)circleView {
    if(!_circleView) {
        _circleView = [[OpenScreenAdCircleView alloc] initWithFrame:CGRectMake(0, 0, kOSASkipButtonSize, kOSASkipButtonSize)];
        _circleView.minNum = 0;
        _circleView.maxNum = 5;
        _circleView.progress = 0.5f;
        _circleView.enableCustom = NO;
    }
    return _circleView;
}

@end
