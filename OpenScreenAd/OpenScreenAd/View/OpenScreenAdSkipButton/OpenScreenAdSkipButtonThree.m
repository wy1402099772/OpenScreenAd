//
//  OpenScreenAdSkipButtonThree.m
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import "OpenScreenAdSkipButtonThree.h"
#import "Masonry.h"
#import "OpenScreenAdCircleView.h"
#import "OpenScreenAdParameters.h"
#import "OpenScreenAdSkipButtonDelegate.h"
#import "OpenScreenAdSkipButtonProtocol.h"

@interface OpenScreenAdSkipButtonThree ()

@property (nonatomic, strong) UILabel *actionButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval logInterval;
@property (nonatomic, assign) BOOL  isSkipEnabled;

@end

@implementation OpenScreenAdSkipButtonThree

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
    if(!self.isSkipEnabled) {
        return ;
    }
    [self.actionButton setText:[NSString stringWithFormat:@"Skip"]];
    [self invalidateTimer];
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
    
    if(!self.isSkipEnabled) {
        [self.actionButton setText:[NSString stringWithFormat:@"%lds", (long)(self.totalSecond - (int)interval)]];
    } else {
        NSInteger leftInterval = (long)(self.totalSecond - (int)interval);
        if(leftInterval > 0) {
            [self.actionButton setText:[NSString stringWithFormat:@"Skip %lds", leftInterval]];
        } else {
            [self.actionButton setText:[NSString stringWithFormat:@"Skip"]];
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
- (UILabel *)actionButton {
    if(!_actionButton) {
        _actionButton = [[UILabel alloc] init];
        _actionButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipButtonDidSelectAction:)];
        [_actionButton addGestureRecognizer:tapGesture];
        _actionButton.backgroundColor = OSA_UIColorFromRGBA(0, 0, 0, 0.4);
        _actionButton.layer.cornerRadius = 5;
        _actionButton.layer.masksToBounds = YES;
        _actionButton.font = [OpenScreenAdParameters getFontRegular:16];
        _actionButton.textAlignment = NSTextAlignmentCenter;
        _actionButton.textColor = [UIColor whiteColor];
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
