//
//  OpenScreenAdHelper.h
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import <Foundation/Foundation.h>
#import "OpenScreenAdViewController.h"

@interface OpenScreenAdHelper : NSObject

+ (instancetype)sharedInstance;

- (void)logOpenScreenAdVC:(OpenScreenAdViewController *)controller;

- (OpenScreenAdViewController *)getLastOpenScreenVC;

@end
