//
//  LKSmartPagingView.h
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/4/23.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSmartPagingViewInfo : NSObject

@property (nonatomic, assign) CGPoint offset;

@end

@interface LKSmartPagingView : UIView

@property (nonatomic, strong) UIView *headerView;                       // 公共header
@property (nonatomic, strong) NSArray<UIScrollView *> *scrollViews;     // 多个横向切换的scrollView
@property (nonatomic, assign) BOOL bouncesEnabled;                      // 是否允许滑出左右边界，默认否

- (instancetype)initWithFrame:(CGRect)frame withScrollViews:(NSArray *)scrollViews andHeaderView:(UIView *)headerView;
- (NSInteger)currentPageIndex;
- (NSInteger)currentPageIndexWithView:(UIScrollView *)scrollView;
- (UIScrollView *)currentScrollView;

@end
