//
// Created by luowei on 15/10/10.
// Copyright (c) 2015 hardy. All rights reserved.
//

#import "LWGridViewCell.h"
#import "LWGridScrollView.h"
#import "LWGridDefines.h"


@implementation LWGridViewCell {
    UIButton *_deleteButton;
}

- (void)setEditing:(BOOL)editing {
    _deleteButton.hidden = !editing;
    _editing = editing;
}

//cell titleLabel的最大大小
-(CGSize)maxCellTitleSize{
    return CGSizeMake(self.frame.size.width + 7,INCH4_7_SCREEN_BIGGER ? 16 : 13);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        CGSize cellSize = self.frame.size;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width,
                cellSize.height + (INCH4_7_SCREEN_BIGGER ? (INCH4_7_SCREEN ? -23 : -27) : -19))];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];

        //删除小叉叉
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_collect_btn"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.hidden = YES;
        _deleteButton.frame = CGRectMake(-Cell_DeleteBtn_H / 2, -Cell_DeleteBtn_H / 2, Cell_DeleteBtn_W, Cell_DeleteBtn_H);

        //文字标题
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(-3.5, cellSize.height - self.maxCellTitleSize.height, cellSize.width + 7, self.maxCellTitleSize.height))];
        _titleLbl.text = @"title";
        _titleLbl.font = [UIFont systemFontOfSize:12];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLbl];

        //给删除按钮添加响应事件
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.iconImageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize cellSize = self.frame.size;
    _iconImageView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height + (INCH4_7_SCREEN_BIGGER ? (INCH4_7_SCREEN ? -23 : -27) : -19));
    _deleteButton.frame = CGRectMake(-Cell_DeleteBtn_W / 2, -Cell_DeleteBtn_H / 2, Cell_DeleteBtn_W, Cell_DeleteBtn_H);

    //设置_titleLbl大小
    [_titleLbl sizeToFit];

    CGFloat titleLblWidth = self.titleLbl.frame.size.width;
    titleLblWidth = titleLblWidth > self.maxCellTitleSize.width ? self.maxCellTitleSize.width:titleLblWidth;

    _titleLbl.center = CGPointMake((CGFloat) (cellSize.width * 0.5), (CGFloat) (cellSize.height - self.maxCellTitleSize.height * 0.5));
    _titleLbl.bounds = CGRectMake(0,0,titleLblWidth,self.maxCellTitleSize.height);


}

//执行删除Cell的操作
- (void)deleteButtonClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(deleteButtonClickedInGridViewCell:)]) {
        [self.delegate deleteButtonClickedInGridViewCell:self];
    }

}

//获得快照视图
- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc] init];

    UIView *cellSnapshotView = nil;
    UIView *deleteButtonSnapshotView = nil;

    CGSize deleteBtnSize = _deleteButton.frame.size;
//    CGSize deleteBtnSize = CGSizeMake(0,0);
    CGSize cellSize = self.frame.size;

    //cell快照
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc] initWithImage:cellSnapshotImage];
    }

    //删除按键快照
    if ([_deleteButton respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        deleteButtonSnapshotView = [_deleteButton snapshotViewAfterScreenUpdates:NO];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(_deleteButton.bounds.size, _deleteButton.opaque, 0);
        [_deleteButton.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *deleteButtonSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        deleteButtonSnapshotView = [[UIImageView alloc] initWithImage:deleteButtonSnapshotImage];
    }


    cellSnapshotView.frame = CGRectMake(0,0,cellSize.width,cellSize.height);
    deleteButtonSnapshotView.frame = CGRectMake(0, 0,deleteBtnSize.width,deleteBtnSize.height);
    deleteButtonSnapshotView.center = CGPointMake(0,0);

    [snapshotView addSubview:cellSnapshotView];
    [snapshotView addSubview:deleteButtonSnapshotView];

    snapshotView.alpha = 0.5;
    snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);

    //构建快照视图
    snapshotView.frame = CGRectMake(0,0,deleteBtnSize.width / 2 + cellSize.width,deleteBtnSize.height / 2 + cellSize.height);

    return snapshotView;
}

@end