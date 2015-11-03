//
//  LWPullDownControl.h
//  Grid-Demo
//
//  Created by luowei on 15/10/22.
//  Copyright (c) 2015 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWPullDownControl : UIRefreshControl

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *imgLogo;

- (instancetype)initWithFrame:(CGRect)frame withBlock:(void (^)())block;

- (void)containingScrollViewDidEndDragging:(UIScrollView *)view;

- (void)containingScrollViewDidScroll:(UIScrollView *)view;


- (void)containingScrollViewDidEndDecelerating:(UIScrollView *)view;

@end
