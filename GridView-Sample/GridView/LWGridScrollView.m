//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//

#import "LWGridScrollView.h"
#import "LWGridViewCell.h"
#import "LWGridScrollViewLayout.h"
#import "LWGridDefines.h"
#import "LWPullDownControl.h"
#import "LWPullDownControl.h"
#import "ViewController.h"

static const int MoveStepDistance = 8;

@interface LWGridScrollView () <LWGridViewDataSource, LWGridViewDelegateFlowLayout, LWGridViewCellDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) LWPullDownControl *searchHeader;

@end

@implementation LWGridScrollView {
    UILongPressGestureRecognizer *_longPressGestureRecognizer;

    NSIndexPath *_movingItemIndexPath;
    NSIndexPath *_preMovingItemIndexPath;
    NSIndexPath *_preDestinationIndexPath;

    BOOL _movedSuceess;

    UIView *_beingMovedPromptView;
    CGPoint _sourceItemCollectionViewCellCenter;
}


- (void)setEditing:(BOOL)editing {
    _editing = editing;
    for (UICollectionViewCell *cell in self.visibleCells) {
        LWGridViewCell *gridViewCell = (LWGridViewCell *) cell;
        //给cell设置editing状态
        [self setGridViewCell:gridViewCell editing:editing];
    }

    //设置下拉控件可用状态
    UISearchBar *search = ((ViewController *)UIViewParentController(self)).searchBar;
    if (editing) {
        //移除下拉搜索
        if (_searchHeader.superview) {
            [_searchHeader removeFromSuperview];
        }
        //地址栏不可用
        search.userInteractionEnabled = NO;

    } else {
        if (!_searchHeader.superview) {
            //添加下拉搜索
            [self addSubview:_searchHeader];
        }
        //地址栏可用
        search.userInteractionEnabled = YES;
    }
}

//给cell设置editing状态
- (void)setGridViewCell:(LWGridViewCell *)gridViewCell editing:(BOOL)editing {
    if ([self indexPathForCell:gridViewCell].item == self.dataArray.count) {
        gridViewCell.editing = NO;
    } else {
        gridViewCell.editing = editing;
    }
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        self.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
        self.alwaysBounceVertical=YES;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];

        [self registerClass:[LWGridViewCell class] forCellWithReuseIdentifier:GridViewCellReuseIdentifier];

        //下拉搜索
        self.searchHeader = [[LWPullDownControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, SearchHeader_H) withBlock:^{
            //处理下拉搜索
            AppDelegate *appDelegate = RCSharedAppDelegate;
            UISearchBar *search = ((ViewController *)UIViewParentController(self)).searchBar;
            if (![search isFirstResponder]) {
                [search becomeFirstResponder];
            }
        }];
        [self addSubview:_searchHeader];

        //给CollectionView添加长按手势
        [self addLongPressGestureRecognizers];

    }

    return self;
}

- (void)dealloc {
    [self removeLongPressGestureRecognizers];
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)reloadData {
    [super reloadData];

    //设置或更新源数据
    [self setupDataArray];
}

//设置源数据
- (void)setupDataArray {
    if (!self.dataArray) {
        self.dataArray = @[].mutableCopy;

        for (int i = 0; i < 30; i++) {

            NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
            [dataDict setValue:[NSString stringWithFormat:@"App %d", i] forKey:@"index"];
            [dataDict setValue:[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]] forKey:@"icon_image"];
            [self.dataArray addObject:dataDict];
        }
    }
}

#pragma mark - UICollectionViewDataSource 实现

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"--------%d:%s---------", __LINE__, __func__);
    LWGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridViewCellReuseIdentifier forIndexPath:indexPath];

    //如果是最后一个格，添加按键
    if (indexPath.item == self.dataArray.count) {
        cell.titleLbl.text = @"添加";
        cell.iconImageView.image = [UIImage imageNamed:@"grid_add_icon_big"];


    } else {
        //设置这个格的文字标题
        NSDictionary *dataDict = self.dataArray[(NSUInteger) indexPath.item];
        cell.titleLbl.text = dataDict[@"index"];
        cell.iconImageView.image = dataDict[@"icon_image"];
    }


    cell.delegate = self;
    //设置编辑状态
    [self setGridViewCell:cell editing:self.editing];

    //重设titleLbl大小
    [cell.titleLbl sizeToFit];

    CGSize cellSize = cell.bounds.size;
    CGFloat titleLblWidth = cell.titleLbl.frame.size.width;
    titleLblWidth = titleLblWidth > cell.maxCellTitleSize.width ? cell.maxCellTitleSize.width : titleLblWidth;

    cell.titleLbl.center = CGPointMake((CGFloat) (cellSize.width * 0.5), (CGFloat) (cellSize.height - cell.maxCellTitleSize.height * 0.5));
    cell.titleLbl.bounds = CGRectMake(0, 0, titleLblWidth, cell.maxCellTitleSize.height);

    return cell;
}

#pragma mark - RCGridViewDataSource 实现

//移动cell的时候调用
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *dataDict = self.dataArray[(NSUInteger) sourceIndexPath.item];
    [self.dataArray removeObjectAtIndex:(NSUInteger) sourceIndexPath.item];
    [self.dataArray insertObject:dataDict atIndex:(NSUInteger) destinationIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    //更新数据到数据库
    [self.gridViewDelegate gridCellDidEndMoving:self.dataArray];
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //index小于添加按键，可移动
    return indexPath.item < self.dataArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    //不能移到indexPath等于添加按键的位置
    return destinationIndexPath.item != self.dataArray.count;
}


#pragma mark - UICollectionViewDelegate 实现

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(LWGridViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"--------%d:%s---------", __LINE__, __func__);

    [cell.titleLbl sizeToFit];

    CGSize cellSize = cell.bounds.size;
    CGFloat titleLblWidth = cell.titleLbl.frame.size.width;
    titleLblWidth = titleLblWidth > cell.maxCellTitleSize.width ? cell.maxCellTitleSize.width : titleLblWidth;

    cell.titleLbl.center = CGPointMake((CGFloat) (cellSize.width * 0.5), (CGFloat) (cellSize.height - cell.maxCellTitleSize.height * 0.5));
    cell.titleLbl.bounds = CGRectMake(0, 0, titleLblWidth, cell.maxCellTitleSize.height);

    //设置编辑状态
    [self setGridViewCell:cell editing:self.editing];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"--------%d:%s---------", __LINE__, __func__);
    return !self.editing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"--------%d:%s---------", __LINE__, __func__);
    LWGridViewCell *cell = (LWGridViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

    //点击响应操作
    [self.gridViewDelegate gridCellDidClicked:cell];
}


#pragma mark -  UIScrollViewDelegate 实现

//当滑动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchHeader containingScrollViewDidScroll:scrollView];
}

//当滑动减速时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.searchHeader containingScrollViewDidEndDecelerating:scrollView];
}

//当松开时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.searchHeader containingScrollViewDidEndDragging:scrollView];
}


//更新scrollView的编辑状态
- (void)updateEditingState:(BOOL)editing {
    self.editing = editing;

    [self.collectionViewLayout invalidateLayout];
}


#pragma mark - RCGridViewCellDelegate 实现

- (void)deleteButtonClickedInGridViewCell:(LWGridViewCell *)cell {


    NSIndexPath *cellIndexPath = [self indexPathForCell:cell];

    if (cellIndexPath) {
        [self.dataArray removeObjectAtIndex:(NSUInteger) cellIndexPath.item];

        //把删除更新到collectionView
        [self performBatchUpdates:^{
            [self deleteItemsAtIndexPaths:@[cellIndexPath]];
        }              completion:nil];
    }

}


#pragma mark - 长按手势处理

//添加longPress手势
- (void)addLongPressGestureRecognizers {
    self.userInteractionEnabled = YES;

    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerTriggerd:)];
    _longPressGestureRecognizer.cancelsTouchesInView = NO;
    _longPressGestureRecognizer.minimumPressDuration = PRESS_TO_MOVE_MIN_DURATION;
    _longPressGestureRecognizer.delegate = self;

    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }

    [self addGestureRecognizer:_longPressGestureRecognizer];
}

//移除longPress手势
- (void)removeLongPressGestureRecognizers {
    if (_longPressGestureRecognizer) {
        if (_longPressGestureRecognizer.view) {
            [_longPressGestureRecognizer.view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = nil;
    }
}

//长按手势响应处理
- (void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPress {

    LWGridScrollView *gridView = (LWGridScrollView *) longPress.view;
    switch (longPress.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {

            //获得长按cell的indexPath (源index)
            _movingItemIndexPath = [self indexPathForItemAtPoint:[longPress locationInView:gridView]];
            if (![self collectionView:self canMoveItemAtIndexPath:_movingItemIndexPath]) {
                _movingItemIndexPath = nil;
                return;
            }

            //如果不是处于编辑状态，设置成编辑状态
            if (!self.editing) {
                self.editing = YES;
                //更新编辑状态
                [self updateEditingState:YES];

            }

            if ([self respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                [self collectionView:self layout:self.collectionViewLayout willBeginDraggingItemAtIndexPath:_movingItemIndexPath];
            }

            LWGridViewCell *sourceGridViewCell = (LWGridViewCell *) [self cellForItemAtIndexPath:_movingItemIndexPath];

            //添加一个被移动的视图,开始移动
            [self addBeingMovedPromptView:sourceGridViewCell];
            _movedSuceess = NO;

            [self.collectionViewLayout invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"========= UIGestureRecognizerStateEnded/Cancelled =========");
            ((LWGridViewCell *) [self cellForItemAtIndexPath:_movingItemIndexPath]).hidden = NO;
        }
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

//手指滑动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    //非编辑模式直接返回
    if (!self.editing) {
        return;
    }

    UITouch *touch = [touches anyObject];

//    CGPoint oldPoint = [touch previousLocationInView:self];
    CGPoint newPoint = [touch locationInView:self];

    //处理拖到底或拖到顶
    //如果newPoint超出屏幕,向上/向下滚
    CGSize movedPromptSize = _beingMovedPromptView.frame.size;
    CGFloat contentOffsetY = self.contentOffset.y;

    //向上拖到顶了
    if (_beingMovedPromptView.frame.origin.y <= contentOffsetY) {
        if (self.contentOffset.y > movedPromptSize.height / 2) {
//            contentOffsetY = self.contentOffset.y - movedPromptSize.height;
            contentOffsetY = self.contentOffset.y - MoveStepDistance;
        } else {
            contentOffsetY = 0;
        }

        //向下拖到底了
    } else if (_beingMovedPromptView.frame.origin.y >= self.frame.size.height + contentOffsetY - movedPromptSize.height) {
        if (self.contentOffset.y + self.frame.size.height < self.contentSize.height) {
//            contentOffsetY = self.contentOffset.y + movedPromptSize.height;
            contentOffsetY = self.contentOffset.y + MoveStepDistance;
            contentOffsetY = contentOffsetY > self.contentSize.height - self.frame.size.height ?
                    self.contentSize.height - self.frame.size.height : contentOffsetY;

        } else {
            contentOffsetY = self.contentSize.height - self.frame.size.height;
        }
    }

    //内容的高度比frame的高度还小,offset.y直接返回-20
    if (self.contentSize.height <= self.frame.size.height) {
        contentOffsetY = -20;
    }

    //设置contentOffset及被移动的快照的位置
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentOffset:CGPointMake(self.contentOffset.x, contentOffsetY) animated:NO];
        if (newPoint.y < 0) {
            _beingMovedPromptView.center = CGPointMake(newPoint.x, 0);
        } else if (newPoint.y > self.contentOffset.y + self.frame.size.height) {
            _beingMovedPromptView.center = CGPointMake(newPoint.x, self.contentOffset.y + self.frame.size.height);
        } else {
            _beingMovedPromptView.center = CGPointMake(newPoint.x, newPoint.y);
        }

    }                completion:^(BOOL finished) {
        if(finished){

            //移动动画
            NSIndexPath *sourceIndexPath = _movingItemIndexPath;
            NSIndexPath *destinationIndexPath = [self indexPathForItemAtPoint:_beingMovedPromptView.center];
            if ((destinationIndexPath != nil) && ![destinationIndexPath isEqual:sourceIndexPath]
                    && [self collectionView:self itemAtIndexPath:sourceIndexPath canMoveToIndexPath:destinationIndexPath]
                    && (![destinationIndexPath isEqual:_preDestinationIndexPath] || ![sourceIndexPath isEqual:_preMovingItemIndexPath])
                    ) {

                [self collectionView:self itemAtIndexPath:sourceIndexPath willMoveToIndexPath:destinationIndexPath];


                //更新movingItemIndexPath
                _movingItemIndexPath = destinationIndexPath;

                //批量移动cell动画
                __weak typeof(self) weakSelf = self;
                [self performBatchUpdates:^{
                    if (weakSelf) {
                        [weakSelf deleteItemsAtIndexPaths:@[sourceIndexPath]];
                        [weakSelf insertItemsAtIndexPaths:@[destinationIndexPath]];
                    }
                }              completion:^(BOOL finished) {
                }];

//        [self.collectionViewLayout invalidateLayout];

                //记住这次移动的index与目标index
                _preMovingItemIndexPath = sourceIndexPath;
                _preDestinationIndexPath = destinationIndexPath;
                _movedSuceess = YES;

            }

        }
    }];

}

//停止滑动
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    //非编辑模式直接返回
    if (!self.editing) {
        return;
    }

    NSIndexPath *sourceIndexPath = _movingItemIndexPath;
    NSIndexPath *destinationIndexPath = [self indexPathForItemAtPoint:_beingMovedPromptView.center];

    if (_movedSuceess) {
        //保存
        if (sourceIndexPath) {

            if ([self respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                [self collectionView:self itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
            }

            if ([self respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                [self collectionView:self layout:self.collectionViewLayout willEndDraggingItemAtIndexPath:sourceIndexPath];
            }
        }
    }

    [_beingMovedPromptView removeFromSuperview];
    _beingMovedPromptView = nil;
    _movingItemIndexPath = nil;
    _preMovingItemIndexPath = nil;
    _preDestinationIndexPath = nil;
    _movedSuceess = NO;

    [self.collectionViewLayout invalidateLayout];

}


//通过快照，构造一个被移动的视图
- (void)addBeingMovedPromptView:(LWGridViewCell *)sourceGridViewCell {

    if (_beingMovedPromptView) {
        [_beingMovedPromptView removeFromSuperview];
        _beingMovedPromptView = nil;
    }

    //构造一个要移动的视图
    _beingMovedPromptView = [[UIView alloc] initWithFrame:sourceGridViewCell.frame];


    //为正常状态的源cell创建一个正常的快照版(隐藏)
    sourceGridViewCell.highlighted = NO;
    UIView *snapshotView = [sourceGridViewCell snapshotView];

    //将两个快照版添加到移动视图中去
    [_beingMovedPromptView addSubview:snapshotView];
    [self addSubview:_beingMovedPromptView];

    if ([self respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
        [self collectionView:self layout:self.collectionViewLayout didBeginDraggingItemAtIndexPath:_movingItemIndexPath];
    }

}



@end