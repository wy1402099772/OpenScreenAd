//
//  OpenScreenAdViewController.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenScreenAdViewControllerDelegate <NSObject>

- (void)openScreenAdDidClickSkipAndWillDismiss;
- (void)openScreenAdDidClickSkipAndDidDismiss;

@end

@interface OpenScreenAdViewController : UIViewController


@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;

@property (nonatomic, weak  ) id<OpenScreenAdViewControllerDelegate> delegate;

@end
