//
//  ViewController.m
//  GridView-Sample
//
//  Created by luowei on 15/11/3.
//  Copyright © 2015年 wodedata. All rights reserved.
//


#import "ViewController.h"
#import "LWGridScrollView.h"
#import "LWGridScrollViewLayout.h"
#import "LWGridViewCell.h"
#import "LWGridDefines.h"




@interface ViewController (){
    //    UICollectionViewFlowLayout * _gridViewFlowLayout;
    LWGridScrollViewLayout * _gridViewFlowLayout;
    UIButton * _homeButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,40)];
    _searchBar.placeholder = @"搜索";
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_searchBar];
    
    _gridViewFlowLayout = [[LWGridScrollViewLayout alloc]init];
    _gridView = [[LWGridScrollView alloc]initWithFrame:CGRectMake(0,60,self.view.bounds.size.width,self.view.bounds.size.height-100)
                                  collectionViewLayout:_gridViewFlowLayout];
    _gridView.backgroundColor = [UIColor whiteColor];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_gridView];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _completeBtn.frame = CGRectMake(0,self.view.bounds.size.height-40,self.view.bounds.size.width,40);
    _completeBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_completeBtn addTarget:self action:@selector(editOK:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_completeBtn];
    
}

//编辑完成
- (void)editOK:(UIButton *)editOK {
    [_gridView updateEditingState:NO];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _searchBar.frame = CGRectMake(0,20,self.view.bounds.size.width,40);
    _gridView.frame = CGRectMake(0,60,self.view.bounds.size.width,self.view.bounds.size.height-100);
    _completeBtn.frame = CGRectMake(0,self.view.bounds.size.height-40,self.view.bounds.size.width,40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
