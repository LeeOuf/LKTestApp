//
//  LKSmartPagingView.h
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/4/23.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKSmartPagingViewDelegate <NSObject>

@optional
- (void)smartPageIndexDidChange:(NSInteger)index withPreviousIndex:(NSInteger)previousIndex;

@end

@interface LKSmartPagingScrollView : UIScrollView

@end

@interface LKSmartPagingView : UIView

@property (nonatomic, strong) UIView *headerView;                       // 公共header
@property (nonatomic, strong) LKSmartPagingScrollView *pageView;
@property (nonatomic, strong) NSArray<UIScrollView *> *scrollViews;     // 多个横向切换的scrollView
@property (nonatomic, assign) BOOL bouncesEnabled;                      // 是否允许滑出左右边界，默认否
@property (nonatomic, weak) id<LKSmartPagingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
               andScrollViews:(NSArray *)scrollViews
                andHeaderView:(UIView *)headerView
            andExtraTopHeight:(CGFloat)extraTopHeight;
- (NSInteger)currentPageIndex;
- (UIScrollView *)currentScrollView;
- (NSInteger)pageIndexWithView:(UIView *)scrollView;
- (void)scrollToPageWithIndex:(NSInteger)index;
- (void)resetAllInsets;

/**
 *  此方法用于将当前显示的scrollView状态与其他scrollView联动
 *  必须由LKSmartPagingView的调用者实现UIScrollViewDelegate方法，并调用本方法
 *  调用本方法的时机有两种，根据情况选择其中一种实现即可：
 *  1. scrollViewDidScroll，每当页面滚动，就对其他页面进行联动
 *  2. scrollViewDidEndDragging、scrollViewDidEndDecelerating、setContentOffest（无动画）、scrollViewDidEndScrollingAnimation等所有滑动操作结束时调用，联动其他页面
 */
- (void)scrollViewsOffsetDidChange:(UIScrollView *)scrollView;

@end
