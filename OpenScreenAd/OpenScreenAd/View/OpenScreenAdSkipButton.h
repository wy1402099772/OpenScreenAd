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

@end

@interface OpenScreenAdSkipButton : UIView

@property (nonatomic, strong) id<OpenScreenAdSkipButtonDelegate> delegate;

@end
