//
//  ViewController.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "OpenScreenAdViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button addTarget:self action:@selector(presentAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"present" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentAction {
    [self presentViewController:[[OpenScreenAdViewController alloc] init] animated:NO completion:nil];
}

@end
