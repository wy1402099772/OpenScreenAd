//
//  OpenScreenAdDismissAnimationView.m
//  Pods
//
//  Created by wyan assert on 2017/4/20.
//
//

#import "OpenScreenAdDismissAnimationView.h"

static CGFloat kOSADismissDelta = 0.06;

@interface OpenScreenAdDismissAnimationView ()

@property (nonatomic, assign) CGFloat   progress;
@property (nonatomic, assign) BOOL      isPositive;
@property (nonatomic, strong) NSTimer   *timer;

@property (nonatomic, copy) OSA_CompletionBlock completion;

@end

@implementation OpenScreenAdDismissAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _progress = 0;
        _isPositive = YES;
        _dismissEndPoint = CGPointMake(-1, -1);
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _progress = 0;
        _isPositive = YES;
        _dismissEndPoint = CGPointMake(-1, -1);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGPoint refPoint = CGPointMake(rect.size.width, rect.size.height);
    CGFloat maxLengh = 0;
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(0, rect.size.height);
    CGPoint point3 = CGPointMake(rect.size.width, 0);
    CGPoint point4 = CGPointMake(rect.size.width, rect.size.height);
    
    CGFloat len1 = [self lengthOfPoint1:self.dismissEndPoint andPoint2:point1];
    CGFloat len2 = [self lengthOfPoint1:self.dismissEndPoint andPoint2:point2];
    CGFloat len3 = [self lengthOfPoint1:self.dismissEndPoint andPoint2:point3];
    CGFloat len4 = [self lengthOfPoint1:self.dismissEndPoint andPoint2:point4];
    
    if(len1 > maxLengh) {
        maxLengh = len1;
        refPoint = point1;
    }
    if(len2 > maxLengh) {
        maxLengh = len2;
        refPoint = point2;
    }
    if(len3 > maxLengh) {
        maxLengh = len3;
        refPoint = point3;
    }
    if(len4 > maxLengh) {
        maxLengh = len4;
        refPoint = point4;
    }
    
    CGRect refRect = [self rectFromCenter:self.dismissEndPoint andPoint:refPoint scale:(1 - _progress)];
    UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:refRect];
    
    bPath.usesEvenOddFillRule = YES;
    [bPath addClip];
    UIImage *image = self.image;
    [image drawInRect:self.bounds];
    CGContextRestoreGState(ctx);
    
}

- (void)startDismissAnimation:(OSA_CompletionBlock)block {
    _isPositive = YES;
    [self awakeTimer:block];
}

- (void)revertDismissAnimation:(OSA_CompletionBlock)block {
    _isPositive = NO;
    [self awakeTimer:block];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)awakeTimer:(OSA_CompletionBlock)block {
    self.completion = block;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60
                                                  target:self
                                                selector:@selector(updateDismissAnimation:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateDismissAnimation:(NSTimer *)timer {
    if(self.isPositive) {
        _progress += [self progressDelta];
        if(_progress >= 1) {
            _progress = 1;
            [self invalidateTimer];
            if(self.completion) {
                self.completion();
                self.completion = nil;
            }
        }
    } else {
        _progress -= [self progressDelta];
        if(_progress <= 0) {
            _progress = 0;
            [self invalidateTimer];
            if(self.completion) {
                self.completion();
                self.completion = nil;
            }
        }
    }
    [self setNeedsDisplay];
}

- (CGFloat)lengthOfPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
}

- (CGRect)rectFromCenter:(CGPoint)center andPoint:(CGPoint)point scale:(CGFloat)progress {
    CGFloat halfWidth = [self lengthOfPoint1:point andPoint2:center] * progress;
    return CGRectMake(center.x - halfWidth,
                      center.y - halfWidth,
                      halfWidth * 2,
                      halfWidth * 2);
}

- (CGFloat)progressDelta {
    CGFloat delta = (0.5 - fabs(_progress - 0.5));
    CGFloat result = 3.6 * kOSADismissDelta * delta + kOSADismissDelta / 10;
    return result;
}


#pragma mark - Getter
- (CGPoint)dismissEndPoint {
    if(_dismissEndPoint.x < 0 && _dismissEndPoint.y < 0) {
        return CGPointZero;
    } else {
        return _dismissEndPoint;
    }
}


@end
