//
//  LKSmartPagingView.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/4/23.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import "LKSmartPagingView.h"
#import "UIView+LKExtension.h"

#define kSmartPagingViewTagSelf             (89999)
#define kSmartPagingViewTagPageView         (90000)
#define kSmartPagingViewTagScrollView       (90001)

@interface LKSmartPagingView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) NSMutableArray<LKSmartPagingViewInfo *> *scrollViewsInfo;     // 记录scrollViews当前滚动位置等信息

@end

@implementation LKSmartPagingView

- (instancetype)initWithFrame:(CGRect)frame withScrollViews:(NSArray *)scrollViews andHeaderView:(UIView *)headerView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView = headerView;
        self.scrollViews = scrollViews;
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc
{
    self.scrollViews = nil;
    self.scrollViewsInfo = nil;
}

- (void)layoutSubviews
{
    self.pageView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Private

- (void)setupSubviews
{
    self.bouncesEnabled = NO;
    [self setupPageView];
    [self setupScrollViews];
    [self setupHeaderView];
    [self layoutSubviews];
}

- (void)setupPageView
{
    self.pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.pageView.contentSize = CGSizeMake(self.pageView.width * self.scrollViews.count, self.pageView.height);
    self.pageView.pagingEnabled = YES;
    self.pageView.delegate = self;
    [self addSubview:self.pageView];
}

- (void)setupScrollViews
{
    NSInteger i = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    self.scrollViewsInfo = [[NSMutableArray alloc] init];
    for (; i < self.scrollViews.count; i++)
    {
        // todo: 数组安全方法
        UIScrollView *scrollView = [self.scrollViews objectAtIndex:i];
        scrollView.frame = CGRectMake(self.pageView.width * i, 0, self.pageView.width, self.pageView.height);
        scrollView.contentInset = insets;
        scrollView.delegate = self;
        [self.pageView addSubview:scrollView];
        
        LKSmartPagingViewInfo *info = [[LKSmartPagingViewInfo alloc] init];
        info.offset = CGPointMake(0, -insets.top);
        [self.scrollViewsInfo addObject:info];
    }
    
    self.currentOffset = CGPointMake(0, -insets.top);
}

- (void)setupHeaderView
{
    UIScrollView *scrollView = [self.scrollViews objectAtIndex:0];
    if (scrollView != nil)
    {
        self.headerView.origin = CGPointMake(0, -self.headerView.height);
        [scrollView addSubview:self.headerView];
    }
}

// 获取/记录 scrollView当前的offset
- (LKSmartPagingViewInfo *)getScrollViewInfo:(UIScrollView *)scrollView
{
    return [self.scrollViewsInfo objectAtIndex:[self pageIndexWithView:scrollView]];
}

- (void)updateScrollViewInfo:(UIScrollView *)scrollView
{
    LKSmartPagingViewInfo *scrollViewInfo = [self getScrollViewInfo:scrollView];
    scrollViewInfo.offset = scrollView.contentOffset;
}

#pragma mark - Public

- (NSInteger)currentPageIndex
{
    return (self.pageView.contentOffset.x / self.pageView.width);
}

- (UIScrollView *)currentScrollView
{
    return [self.scrollViews objectAtIndex:[self currentPageIndex]];
}

- (NSInteger)pageIndexWithView:(UIView *)scrollView
{
    NSInteger index = -1;
    NSInteger i = 0;
    for (; i < self.scrollViews.count; i++)
    {
        if ([self.scrollViews objectAtIndex:i] == scrollView) {
            index = i;
            break;
        }
    }
    
    return index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self pageIndexWithView:scrollView] >= 0)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        // 若是当前主动滑动的scrollView，则开始其他scrollView的联动
        if ([self currentScrollView] == scrollView)
        {
            self.currentOffset = scrollView.contentOffset;
            [self updateScrollViewInfo:scrollView];
            
            for(UIScrollView *tempView in self.scrollViews)
            {
                if (tempView != scrollView)
                {
                    if (offsetY <= 0)                                           // header仍在界面中时
                    {
                        // 同步滑动其他视图
                        tempView.contentOffset = scrollView.contentOffset;
                    }
                    else if (scrollView.contentOffset.y > 0)                    // header在界面中消失时
                    {
                        if ([self getScrollViewInfo:tempView].offset.y >= 0)    // 若其他scrollView之前已经将headerView滑出，则恢复原本的offset
                        {
                            tempView.contentOffset = [self getScrollViewInfo:tempView].offset;
                        }
                        else if (tempView.contentOffset.y < 0)                  // 若其他scrollView原来未将headerView滑出，现在也未滑出，则将其headerView滑出
                        {
                            tempView.contentOffset = CGPointZero;
                        }
                    }
                }
            }
        }
    }
    
    if (scrollView == self.pageView)
    {
        // 禁止滑出左右边界
        if (!self.bouncesEnabled)
        {
            self.pageView.bounces = (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= self.pageView.contentSize.width) ? NO : YES;
        }
        
        if ([self pageIndexWithView:self.headerView.superview] >= 0)
        {
            [self.headerView removeFromSuperview];
            self.headerView.top = -(self.currentOffset.y + self.headerView.height);
            [self addSubview:self.headerView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageView)
    {
        if (self.headerView.superview == self)
        {
            [self.headerView removeFromSuperview];
            self.headerView.top = -self.headerView.height;
            [[self currentScrollView] addSubview:self.headerView];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint childP = [self convertPoint:location toView:self.headerView];
    if ([self.headerView pointInside:childP withEvent:event])
    {
            [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else
    {
    
        [super touchesBegan: touches withEvent: event];
    }
}


@end

@implementation LKSmartPagingViewInfo

@end
