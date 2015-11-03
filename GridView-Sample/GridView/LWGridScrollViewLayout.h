//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//
//应用九宫格布局

#import <UIKit/UIKit.h>

@class LWGridScrollView;
@class LWGridViewCell;
@class LWGridViewCell;
@protocol LWGridScrollViewDelegate;


@interface LWGridScrollViewLayout : UICollectionViewFlowLayout<UIGestureRecognizerDelegate>

@end

@protocol LWGridViewDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol LWGridViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol LWGridScrollViewDelegate <NSObject>

- (void)gridCellDidBeginEditing;
- (void)gridCellDidClicked:(LWGridViewCell *)item;
- (void)gridCellDidEndMoving:(NSArray *)dataSource;

@end