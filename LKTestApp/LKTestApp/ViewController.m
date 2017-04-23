//
//  ViewController.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 16/9/23.
//  Copyright © 2016年 Li,Ke(BBTD). All rights reserved.
//

#import "ViewController.h"
#import "LKTableView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) LKTableView *table1;
@property (nonatomic, strong) LKTableView *table2;
@property (nonatomic, assign) NSInteger scrollingViewTag;
@property (nonatomic, assign) CGFloat currentOffest;
@property (nonatomic, assign) CGPoint table1LastOffest;
@property (nonatomic, assign) CGPoint table2LastOffest;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, self.view.width, 200)];
    self.topView.backgroundColor = [UIColor redColor];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 140, 40)];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btn1];
    
    UIScrollView *testView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 200, 100)];
    testView.contentSize = CGSizeMake(400, 100);
    testView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:testView];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    btn2.backgroundColor = [UIColor grayColor];
    [testView addSubview:btn2];
    
    
    self.pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.pageView.backgroundColor = [UIColor clearColor];
    self.pageView.contentSize = CGSizeMake(self.view.width * 2, self.view.height);
    self.pageView.tag = 2;
    self.pageView.delegate = self;
    self.pageView.pagingEnabled = YES;
    [self.view addSubview:self.pageView];
    
    self.table1 = [LKTableView contentTableView];
    self.table2 = [LKTableView contentTableView];
    self.table1.backgroundColor = [UIColor clearColor];
    self.table2.backgroundColor = [UIColor clearColor];
    self.table2.left = self.table2.right;
    self.table1.contentInset = UIEdgeInsetsMake(self.topView.height, 0, 0, 0);
    self.table2.contentInset = UIEdgeInsetsMake(self.topView.height, 0, 0, 0);
    self.table1.tag = 11;
    self.table2.tag = 12;
    ((UIScrollView *)self.table1).delegate = self;
    ((UIScrollView *)self.table2).delegate = self;
    [self.pageView addSubview:self.table1];
    [self.pageView addSubview:self.table2];
    
    [self.table1 addSubview:self.topView];
}

- (void)onClick
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 11 || scrollView.tag == 12)
    {
        self.currentOffest = scrollView.contentOffset.y;
        
        // header仍在界面中时，同步滑动其他视图
        if (scrollView.contentOffset.y <= 0 && scrollView.contentOffset.y >= -self.topView.height)
        {
            if (self.scrollingViewTag == 0)
            {
                self.scrollingViewTag = scrollView.tag;
            }
            
            if (scrollView.tag == 11 && scrollView.tag == self.scrollingViewTag) {
                self.scrollingViewTag = scrollView.tag;
                self.table2.contentOffset = scrollView.contentOffset;
            }
            else if (scrollView.tag == 12 && scrollView.tag == self.scrollingViewTag)
            {
                self.scrollingViewTag = scrollView.tag;
                self.table1.contentOffset = scrollView.contentOffset;
            }
        }
        else if (scrollView.contentOffset.y > 0)    // header在界面中消失时
        {
            if (scrollView.tag == 11 && scrollView.tag == self.scrollingViewTag)
            {
                if (self.table2LastOffest.y >= 0)
                {
                    self.table2.contentOffset = self.table2LastOffest;
                }
                // 将其他视图滑动到header底部
                else if (self.table2.contentOffset.y < 0)
                {
                    self.table2.contentOffset = CGPointZero;
                }
            }
            else if (scrollView.tag == 12 && scrollView.tag == self.scrollingViewTag)
            {
                if (self.table1LastOffest.y >= 0)
                {
                    self.table1.contentOffset = self.table1LastOffest;
                }
                else if (self.table1.contentOffset.y < 0)
                {
                    self.table1.contentOffset = CGPointZero;
                }
            }
        }
        
        if (scrollView.tag == 11 && scrollView.tag == self.scrollingViewTag)
        {
            self.scrollingViewTag = scrollView.tag;
            self.table1LastOffest = scrollView.contentOffset;
        }
        else if (scrollView.tag == 12 && scrollView.tag == self.scrollingViewTag)
        {
            self.scrollingViewTag = scrollView.tag;
            self.table2LastOffest = scrollView.contentOffset;
        }
    }
    
    if (scrollView.tag == 2)
    {
        if ([self.topView.superview class] == LKTableView.class)
        {
            [self.topView removeFromSuperview];
            self.topView.top = -(self.currentOffest + self.topView.height);
            [self.view addSubview:self.topView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 2)
    {
        if ([self.topView.superview class] == UIView.class)
        {
            [self.topView removeFromSuperview];
            self.topView.top = -self.topView.height;
            if (scrollView.contentOffset.x >= self.view.width) {
                [self.table2 addSubview:self.topView];
            }
            else
            {
                [self.table1 addSubview:self.topView];
            }
        }
    }
    self.scrollingViewTag = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

@end
