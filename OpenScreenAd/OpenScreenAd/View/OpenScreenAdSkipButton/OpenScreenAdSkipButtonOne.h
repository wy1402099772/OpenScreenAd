//
//  OpenScreenAdSkipButtonOne.h
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import <UIKit/UIKit.h>
#import "OpenScreenAdSkipButtonProtocol.h"

@protocol OpenScreenAdSkipButtonDelegate;

@interface OpenScreenAdSkipButtonOne : UIView <OpenScreenAdSkipButtonProtocol>

@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;
@property (nonatomic, assign) NSUInteger delaySecond;

@property (nonatomic, strong) id<OpenScreenAdSkipButtonDelegate> delegate;

@end
