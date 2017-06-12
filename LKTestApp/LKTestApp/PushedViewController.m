//
//  PushedViewController.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/5/15.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import "PushedViewController.h"
#import "LKTableView.h"
#import "LKSmartPagingView.h"

@interface PushedViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LKTableView *table1;
@property (nonatomic, strong) LKTableView *table2;
@property (nonatomic, strong) LKTableView *table3;
@property (nonatomic, strong) LKSmartPagingView *smartView;

@end

@implementation PushedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

//    UIScrollView *pageView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    pageView.contentSize = CGSizeMake(self.view.width * 3, self.view.height);
//    self.table1 = [LKTableView contentTableView:20];
//    self.table2 = [LKTableView contentTableView:5];
//    self.table3 = [LKTableView contentTableView:30];
//    self.table1.backgroundColor = [UIColor redColor];
//    self.table2.backgroundColor = [UIColor blueColor];
//    self.table3.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:pageView];
//    pageView.pagingEnabled = YES;
//    [pageView addSubview:self.table1];
//    [pageView addSubview:self.table2];
//    [pageView addSubview:self.table3];
//    self.table1.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    self.table2.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
//    self.table3.frame = CGRectMake(self.view.width * 2, 0, self.view.width, self.view.height);
    
    
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
    self.smartView = [[LKSmartPagingView alloc] initWithFrame:self.view.bounds andScrollViews:scrollViews andHeaderView:self.headerView andExtraTopHeight:0];
    [self.view addSubview:self.smartView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.smartView scrollViewsOffsetDidChange:scrollView];
}

@end

