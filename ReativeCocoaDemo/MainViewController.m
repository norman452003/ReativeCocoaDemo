//
//  MainViewController.m
//  ReativeCocoaDemo
//
//  Created by suning on 15/9/17.
//  Copyright (c) 2015年 gong. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
