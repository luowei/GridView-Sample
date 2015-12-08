//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//
//首页应用里九宫格视图

#import <UIKit/UIKit.h>

@class LWPullDownControl;
@protocol LWGridScrollViewDelegate;


@interface LWGridScrollView : UICollectionView

@property (nonatomic, assign) id<LWGridScrollViewDelegate> gridViewDelegate;

//@property (nonatomic,assign) BOOL editing;

@property(nonatomic, retain) NSMutableArray *dataArray;

@property(nonatomic, assign) BOOL editing;


@property(nonatomic, strong) NSIndexPath *movingItemIndexPath;

- (void)updateEditingState:(BOOL)editing;
@end