//
//  AppDelegate.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "OpenScreenAdViewController.h"

@interface AppDelegate () <OpenScreenAdViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *controller = [[ViewController alloc] init];
    self.window.rootViewController =  controller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    OpenScreenAdViewController *adController = [[OpenScreenAdViewController alloc] init];
    
    [adController configureMobAdWithApplicationID:@"ca-app-pub-3176063063432139~5059019809"];
    [adController configureWithAdMobUnitId:@"ca-app-pub-3176063063432139/9764983002"];
    
    [adController setAppID:@"29403" apiKey:@"7e03a2daee806fefa292d1447ea50155"];
    [adController configureWithUnitId:@"3763"];
    
    adController.allowSkipSecond = 3;
    adController.totalSecond = 5;
    adController.waitSecond = 3;
    adController.delaySecond = 1;
    
    adController.shouldShowDismissAnimation = YES;
    adController.dismissEndPoint = CGPointMake(150, 125);
    
    adController.delegate = self;
    
    [adController startLoadAd];
    
    [controller addChildViewController:adController];
    [adController willMoveToParentViewController:controller];
    [controller.view addSubview:adController.view];
    [adController didMoveToParentViewController:controller];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - OpenScreenAdViewControllerDelegate

- (BOOL)shouldOpenScreenAdVCDismissWhenCountDownOrSkip {
    return NO;
}

- (void)openScreenAdDidCountDownOrSkip:(UIViewController *)adViewController {
    
}

- (void)openScreenAdDidClickSkipAndWillDismiss:(UIViewController *)adViewController {
    
}

- (void)openScreenAdDidClickSkipAndDidDismiss:(UIViewController *)adViewController {
    [adViewController.view removeFromSuperview];
    [adViewController removeFromParentViewController];
}

@end
