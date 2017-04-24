//
//  ViewController.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 16/9/23.
//  Copyright © 2016年 Li,Ke(BBTD). All rights reserved.
//

#import "ViewController.h"
#import "LKTableView.h"
#import "LKSmartPagingView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LKTableView *table1;
@property (nonatomic, strong) LKTableView *table2;
@property (nonatomic, strong) LKTableView *table3;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, self.view.width, 200)];
    self.headerView.backgroundColor = [UIColor redColor];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 140, 40)];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:btn1];
    
    UIScrollView *testView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 200, 100)];
    testView.contentSize = CGSizeMake(400, 100);
    testView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:testView];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    btn2.backgroundColor = [UIColor grayColor];
    [testView addSubview:btn2];
    
    self.table1 = [LKTableView contentTableView:20];
    self.table2 = [LKTableView contentTableView:2];
    self.table3 = [LKTableView contentTableView:30];
    self.table1.backgroundColor = [UIColor clearColor];
    self.table2.backgroundColor = [UIColor clearColor];
    self.table3.backgroundColor = [UIColor clearColor];
    ((UIScrollView *)self.table1).delegate = self;
    ((UIScrollView *)self.table2).delegate = self;
    ((UIScrollView *)self.table3).delegate = self;
    
    NSMutableArray *scrollViews = [[NSMutableArray alloc] init];
    [scrollViews addObject:self.table1];
    [scrollViews addObject:self.table2];
    [scrollViews addObject:self.table3];
    LKSmartPagingView *smartView = [[LKSmartPagingView alloc] initWithFrame:self.view.bounds withScrollViews:scrollViews andHeaderView:self.headerView];
    [self.view addSubview:smartView];
}

- (void)onClick
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
