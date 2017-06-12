//
//  LKSmartPagingView.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/4/23.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//


#import "LKSmartPagingView.h"
#import "UIView+LKExtension.h"
#import "NSArray+LKExtension.h"

@implementation LKSmartPagingScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self panBack:gestureRecognizer])
    {
        return NO;
    }
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer)
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state)
        {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < self.width && self.contentOffset.x <= 0)
            {
                return YES;
            }
        }
    }
    return NO;
}

@end

@interface LKSmartPagingViewInfo : NSObject

@property (nonatomic, assign) CGPoint offset;

@end

@implementation LKSmartPagingViewInfo

@end

@interface LKSmartPagingView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pageViewGesture;
@property (nonatomic, assign) BOOL isPaningHeaderView;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) NSMutableArray<LKSmartPagingViewInfo *> *scrollViewsInfo;     // 记录scrollViews当前滚动位置等信息
@property (nonatomic, assign) NSInteger lastPageIndex;
@property (nonatomic, assign) CGFloat extraTopHeight;

@end

@implementation LKSmartPagingView

- (instancetype)initWithFrame:(CGRect)frame
               andScrollViews:(NSArray *)scrollViews
                andHeaderView:(UIView *)headerView
            andExtraTopHeight:(CGFloat)extraTopHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView = headerView;
        self.scrollViews = scrollViews;
        self.extraTopHeight = extraTopHeight;
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc
{
    self.pageView.delegate = nil;
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
    self.isPaningHeaderView = NO;
    self.lastPageIndex = 0;
    [self setupPageView];
    [self setupScrollViews];
    [self setupHeaderView];
    [self layoutSubviews];
}

- (void)setupPageView
{
    self.pageView = [[LKSmartPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.pageView.contentSize = CGSizeMake(self.pageView.width * self.scrollViews.count, self.pageView.height);
    self.pageView.pagingEnabled = YES;
    self.pageView.showsHorizontalScrollIndicator = NO;
    self.pageView.showsVerticalScrollIndicator = NO;
    self.pageView.delegate = self;
    self.pageView.bounces = self.bouncesEnabled;
    [self addSubview:self.pageView];
    
    self.pageViewGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    self.pageViewGesture.delegate = self;
    [self.pageView addGestureRecognizer:self.pageViewGesture];
}

- (void)onPan:(UIPanGestureRecognizer *)panGesture
{
    // do nothing
}

- (void)setupScrollViews
{
    NSInteger i = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    self.scrollViewsInfo = [[NSMutableArray alloc] init];
    for (; i < self.scrollViews.count; i++)
    {
        UIScrollView *scrollView = [self.scrollViews safeObjectAtIndex:i];
        scrollView.frame = CGRectMake(self.pageView.width * i, 0, self.pageView.width, self.pageView.height);
        scrollView.contentInset = insets;
        scrollView.contentOffset = CGPointMake(0, -insets.top);
        [self.pageView addSubview:scrollView];
        
        LKSmartPagingViewInfo *info = [[LKSmartPagingViewInfo alloc] init];
        info.offset = CGPointMake(0, -insets.top);
        [self.scrollViewsInfo safeAddObject:info];
    }
    
    self.currentOffset = CGPointMake(0, -insets.top);
}

- (void)setupHeaderView
{
    UIScrollView *scrollView = [self.scrollViews safeObjectAtIndex:0];
    if (scrollView != nil)
    {
        self.headerView.origin = CGPointMake(0, -self.headerView.height);
        [scrollView addSubview:self.headerView];
    }
}

// 获取/记录 scrollView当前的offset
- (LKSmartPagingViewInfo *)getScrollViewInfo:(UIScrollView *)scrollView
{
    return [self.scrollViewsInfo safeObjectAtIndex:[self pageIndexWithView:scrollView]];
}

- (void)updateScrollViewInfo:(UIScrollView *)scrollView
{
    LKSmartPagingViewInfo *scrollViewInfo = [self getScrollViewInfo:scrollView];
    scrollViewInfo.offset = scrollView.contentOffset;
}

#pragma mark - Public

- (NSInteger)currentPageIndex
{
    return ((self.pageView.contentOffset.x / self.pageView.width) + 0.5);
}

- (UIScrollView *)currentScrollView
{
    return [self.scrollViews safeObjectAtIndex:[self currentPageIndex]];
}

- (NSInteger)pageIndexWithView:(UIView *)scrollView
{
    return scrollView.left / self.pageView.width;
}

- (void)scrollToPageWithIndex:(NSInteger)index
{
    [self.pageView setContentOffset:CGPointMake(self.pageView.width * index, 0) animated:NO];
    [self pageViewDidStopMoving:self.pageView];
}

- (void)resetAllInsets
{
    self.headerView.origin = CGPointMake(0, -self.headerView.height);
    NSInteger i = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    for (; i < self.scrollViews.count; i++)
    {
        UIScrollView *scrollView = [self.scrollViews safeObjectAtIndex:i];
        scrollView.contentInset = insets;
        scrollView.contentOffset = CGPointMake(0, -insets.top);
    }
    
    // 更改scrollView的contentOffest后再重设缓存，防止滑动过程中的联动使缓存错乱
    for (LKSmartPagingViewInfo *info in self.scrollViewsInfo)
    {
        info.offset = CGPointMake(0, -insets.top);
    }
    
    self.currentOffset = CGPointMake(0, -insets.top);
}

- (void)pageViewDidStopMoving:(UIScrollView *)scrollView
{
    if (scrollView == self.pageView)
    {
        if (self.headerView.superview != [self currentScrollView])
        {
            [self.headerView removeFromSuperview];
            self.headerView.top = -self.headerView.height;
            [[self currentScrollView] addSubview:self.headerView];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(smartPageIndexDidChange:withPreviousIndex:)])
        {
            [self.delegate smartPageIndexDidChange:[self currentPageIndex] withPreviousIndex:self.lastPageIndex];
        }
        
        // 记录此次拖动结束后位置
        self.lastPageIndex = [self currentPageIndex];
    }
}

- (void)scrollViewsOffsetDidChange:(UIScrollView *)scrollView
{
    // 若是当前主动滑动的scrollView，则开始其他scrollView的联动
    if ([self currentScrollView] == scrollView)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        self.currentOffset = scrollView.contentOffset;
        [self updateScrollViewInfo:scrollView];
        
        for(UIScrollView *tempView in self.scrollViews)
        {
            if (tempView != scrollView)
            {
                if (offsetY <= -self.extraTopHeight && offsetY >= -self.headerView.height)     // header仍在界面中但未拉长时
                {
                    // 同步滑动其他视图
                    tempView.contentOffset = scrollView.contentOffset;
                }
                else if (offsetY < -self.headerView.height)                                    // header仍在界面中并拉长时
                {
                    tempView.contentOffset = CGPointMake(0, -self.headerView.height);
                }
                else if (offsetY > -self.extraTopHeight)                                       // header在界面中消失时
                {
                    if ([self getScrollViewInfo:tempView].offset.y >= -self.extraTopHeight)    // 若其他scrollView之前已经将headerView滑出，则恢复原本的offset
                    {
                        tempView.contentOffset = [self getScrollViewInfo:tempView].offset;
                    }
                    else                                                                       // 若其他scrollView原来未将headerView滑出，则将其headerView滑出
                    {
                        tempView.contentOffset = CGPointMake(0, -self.extraTopHeight);
                    }
                }
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.pageView)
    {
        if (self.isPaningHeaderView)
        {
            scrollView.contentOffset = CGPointMake([self currentPageIndex] * self.pageView.width, 0);
        }
        else if (self.headerView.superview != self)
        {
            [self.headerView removeFromSuperview];
            self.headerView.top = -(self.currentOffset.y + self.headerView.height);
            [self addSubview:self.headerView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.pageView)
    {
        // 用户左右滑动但拖拽回原处
        if (!decelerate)
        {
            [self pageViewDidStopMoving:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageView)
    {
        // 由于pagingEnabled，正常滑动时不会触发scrollViewDidEndDragging
        [self pageViewDidStopMoving:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.pageView)
    {
        [self pageViewDidStopMoving:scrollView];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.pageViewGesture)
    {
        CGPoint location = [gestureRecognizer locationInView:self.headerView];
        // 判断是否在headerView部分滑动
        if (location.x >= 0 && location.x <= self.headerView.width && location.y >= 0 && location.y <= self.headerView.height)
        {
            self.isPaningHeaderView = YES;
        }
        else
        {
            self.isPaningHeaderView = NO;
        }
    }
    // 无论如何返回NO，使pageVeiw响应UIScrollView滑动而不是响应手势
    return NO;
}

@end
