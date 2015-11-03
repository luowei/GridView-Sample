//
//  LWPullDownControl.m
//  Grid-Demo
//
//  Created by luowei on 15/10/22.
//  Copyright (c) 2015 wodedata. All rights reserved.
//

#import "LWPullDownControl.h"

static CGFloat const minOffsetToTrigger = 70.0f;

@interface LWPullDownControl ()
@property(nonatomic, copy) void (^pullDownBlock)();
@end

@implementation LWPullDownControl


- (instancetype)initWithFrame:(CGRect)frame withBlock:(void (^)())block {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
        _titleLabel.text = @"下拉搜索";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor grayColor];
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(frame.size.width / 2 + 15, frame.size.height/2);
        [self addSubview:_titleLabel];

        //logo
        self.imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _imgLogo.center = CGPointMake(_titleLabel.frame.origin.x - 15, frame.size.height/2);
        _imgLogo.image = [UIImage imageNamed:@"pullDown_search_icon@3x"];
        [self addSubview:_imgLogo];

        self.pullDownBlock = block;

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _titleLabel.center = CGPointMake(self.frame.size.width / 2 + 15, self.frame.size.height/2);
    _imgLogo.center = CGPointMake(_titleLabel.frame.origin.x - 15, self.frame.size.height/2);

}

//当包含自己的scrollView滑动时
- (void)containingScrollViewDidScroll:(UIScrollView *)containingScrollView {
    if(!self.superview){
        return;
    }

    //文字图片显示出来
    if(containingScrollView.contentOffset.y <= -20){
        [UIView animateWithDuration:0.2 animations:^{
            _titleLabel.alpha = 1;
            _imgLogo.alpha = 1;
        }];
    }

    //下拉距大于minOffsetToTrigger改变颜色
    if (containingScrollView.contentOffset.y <= -minOffsetToTrigger) {
        _titleLabel.textColor = [UIColor blueColor];
        _imgLogo.image = [UIImage imageNamed:@"searchblue_icon@3x"];
    }else{
        _titleLabel.textColor = [UIColor grayColor];
        _imgLogo.image = [UIImage imageNamed:@"pullDown_search_icon@3x"];
    }
}

//当包含自己的scrollView滑动减速时
- (void)containingScrollViewDidEndDecelerating:(UIScrollView *)containingScrollView {
    if(!self.superview){
        return;
    }

}

//当包含自己的scrollView松开时
- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView {
    if(!self.superview){
        return;
    }

    if (containingScrollView.contentOffset.y <= -minOffsetToTrigger) {
        [self sendAction:@selector(pullDownSearch) to:self forEvent:nil];
    }

    if(containingScrollView.contentOffset.y > -20){
        [UIView animateWithDuration:0.2 animations:^{
            _titleLabel.alpha = 0;
            _imgLogo.alpha = 0;
        }];
    }

}

//下拉触发搜索时调用
- (void)pullDownSearch {
    self.pullDownBlock();
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.05];
}


@end
