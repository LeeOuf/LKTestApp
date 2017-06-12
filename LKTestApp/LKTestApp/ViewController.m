//
//  ViewController.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 16/9/23.
//  Copyright © 2016年 Li,Ke(BBTD). All rights reserved.
//

#import "ViewController.h"
#import "PushedViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar *testBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, 264, 50)];
    [testBar setPositionAdjustment:UIOffsetMake(-5, 0) forSearchBarIcon:UISearchBarIconClear];
    [testBar setSearchTextPositionAdjustment:UIOffsetMake(7, 0)];
    [self.view addSubview:testBar];
//    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
//    testBtn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:testBtn];
//    [testBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick:(id)sender
{
    PushedViewController *testVC = [[PushedViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
