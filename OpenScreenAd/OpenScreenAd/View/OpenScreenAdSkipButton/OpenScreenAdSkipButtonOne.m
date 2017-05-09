//
//  OpenScreenAdSkipButtonOne.m
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import "OpenScreenAdSkipButtonOne.h"
#import "Masonry.h"
#import "OpenScreenAdCircleView.h"
#import "OpenScreenAdParameters.h"
#import "OpenScreenAdSkipButtonDelegate.h"
#import "OpenScreenAdSkipButtonProtocol.h"

@interface OpenScreenAdSkipButtonOne ()

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval logInterval;
@property (nonatomic, assign) BOOL  isSkipEnabled;

@end

@implementation OpenScreenAdSkipButtonOne

@synthesize allowSkipSecond = _allowSkipSecond;
@synthesize totalSecond = _totalSecond;
@synthesize delaySecond = _delaySecond;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}

- (instancetype)init {
    if(self = [super init]) {
        [self configureView];
    }
    return self;
}


#pragma mark - Public
- (void)startCountdown {
    [self performSelector:@selector(prepareToCountDown) withObject:nil afterDelay:self.delaySecond];
}

- (void)forceToCountDown {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(prepareToCountDown) object:nil];
    if(self.timer) {
        return ;
    }
    [self prepareToCountDown];
}

- (NSUInteger)getRunSecond {
    return [[NSDate date] timeIntervalSince1970] - self.logInterval;
}

#pragma mark - Private
- (void)configureView {
    self.hidden = YES;
    
    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
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
//    [self.actionButton setTitle:@"SKIP" forState:UIControlStateNormal];
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
    [self invalidateTimer];
    [self.actionButton setTitle:[NSString stringWithFormat:@"Skip"] forState:UIControlStateNormal];
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
    self.actionButton.enabled = self.isSkipEnabled;
    
    if(!self.isSkipEnabled) {
        [self.actionButton setTitle:[NSString stringWithFormat:@"%lds", (long)(self.totalSecond - (int)interval)] forState:UIControlStateNormal];
    } else {
        NSInteger leftInterval = (long)(self.totalSecond - (int)interval);
        if(leftInterval > 0) {
            [self.actionButton setTitle:[NSString stringWithFormat:@"Skip %lds", leftInterval] forState:UIControlStateNormal];
        } else {
            [self.actionButton setTitle:[NSString stringWithFormat:@"Skip"] forState:UIControlStateNormal];
        }
    }
}


#pragma mark - Setter
- (void)setAllowSkipSecond:(NSUInteger)allowSkipSecond {
    _allowSkipSecond = allowSkipSecond;
}

- (void)setTotalSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
}

- (void)setDelaySecond:(NSUInteger)delaySecond {
    _delaySecond = delaySecond;
}

- (void)setDelegate:(id<OpenScreenAdSkipButtonDelegate>)delegate {
    _delegate = delegate;
}

#pragma mark - Getter
- (UIButton *)actionButton {
    if(!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        [_actionButton addTarget:self action:@selector(skipButtonDidSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.backgroundColor = [UIColor whiteColor];
        _actionButton.layer.cornerRadius = 18;
        _actionButton.layer.masksToBounds = YES;
        _actionButton.titleLabel.font = [OpenScreenAdParameters getFontRegular:12];
        _actionButton.layer.borderWidth = 0.5;
        _actionButton.layer.borderColor = OSA_UIColorFromRGB(215, 215, 215).CGColor;
        [_actionButton setTitleColor:OSA_UIColorFromRGB(104, 104, 104) forState:UIControlStateNormal];
        _actionButton.titleLabel.font = [OpenScreenAdParameters getFontRegular:12];
    }
    return _actionButton;
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
