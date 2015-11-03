//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//
//首页应用里九宫格视图的卡片视图

#import <UIKit/UIKit.h>

@class LWGridScrollView;
@class LWGridViewCell;


@protocol LWGridViewCellDelegate <NSObject>

//删除一个宫格卡片
- (void)deleteButtonClickedInGridViewCell:(LWGridViewCell *)gridViewCell;

@end

@interface LWGridViewCell : UICollectionViewCell

@property (nonatomic,assign) BOOL editing;

@property (nonatomic,assign) id<LWGridViewCellDelegate> delegate;

@property (nonatomic,retain) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel *titleLbl;


//cell titleLabel的最大大小
-(CGSize)maxCellTitleSize;

//cell快照
- (UIView *)snapshotView;
@end