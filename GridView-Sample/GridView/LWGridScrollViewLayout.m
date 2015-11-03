//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//

#import <objc/objc.h>
#import "LWGridScrollViewLayout.h"
#import "LWGridDefines.h"
#import "LWGridScrollView.h"
#import "LWGridViewCell.h"


@interface LWGridScrollViewLayout ()

@property(nonatomic, readonly) id <LWGridViewDataSource> dataSource;
@property(nonatomic, readonly) id <LWGridViewDelegateFlowLayout> delegate;
@property(nonatomic, assign) BOOL editing;

@end


@implementation LWGridScrollViewLayout {

}


- (instancetype)init {
    if (self = [super init]) {
        //设置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置整个节的上、左、底、右间距
        self.sectionInset = UIEdgeInsetsMake(8, 24, 8, 24);
        //设置Cell行与行之间的最小线宽(2倍Cell间距),列与列之间的最小间距
        self.minimumLineSpacing = 16;
        self.minimumInteritemSpacing = 16;
        //设置cell的大小
        self.itemSize = CGSizeMake(Grid_Cell_W, Grid_Cell_H);
    }
    return self;
}


#pragma mark - 重载 UICollectionViewLayout 方法

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];

    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {

        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:((LWGridScrollView *)self.collectionView).movingItemIndexPath];
        }
    }
    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWGridScrollView *gridView = (LWGridScrollView *)self.collectionView;
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:gridView.movingItemIndexPath];
    }
    return layoutAttributes;
}

@end