//
//  OpenScreenAdHelper.m
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import "OpenScreenAdHelper.h"

@interface OpenScreenAdHelper ()

@property (nonatomic, strong) OpenScreenAdViewController *controller;

@end

@implementation OpenScreenAdHelper

+ (instancetype)sharedInstance {
    static OpenScreenAdHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OpenScreenAdHelper alloc] init];
    });
    return instance;
}

- (void)logOpenScreenAdVC:(OpenScreenAdViewController *)controller {
    self.controller = controller;
}

- (OpenScreenAdViewController *)getLastOpenScreenVC {
    return self.controller;
}


@end
