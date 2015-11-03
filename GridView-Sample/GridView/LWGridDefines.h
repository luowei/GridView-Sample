//
//  RCGridDefines.h
//  Grid-Demo
//
//  Created by luowei on 15/10/13.
//  Copyright (c) 2015 wodedata. All rights reserved.
//

#ifndef Grid_Demo_RCGridDefines_h
#define Grid_Demo_RCGridDefines_h

#import <UIKit/UIKit.h>

#ifndef INCH4_SCREEN
#define INCH4_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef INCH3_5_SCREEN
#define INCH3_5_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef INCH4_7_SCREEN
#define INCH4_7_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef INCH5_5_SCREEN
#define INCH5_5_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef INCH5_5_SCREEN_MAGNIFY
#define INCH5_5_SCREEN_MAGNIFY ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef INCH4_SCREEN_BIGGER
#define INCH4_SCREEN_BIGGER ([[UIScreen mainScreen] currentMode].size.height>=1136 ? YES: NO)
#endif

#ifndef INCH4_7_SCREEN_BIGGER
#define INCH4_7_SCREEN_BIGGER ([[UIScreen mainScreen] currentMode].size.height>=1334 ? YES: NO)
#endif


#define Grid_Cell_W (INCH4_7_SCREEN_BIGGER ? (INCH4_7_SCREEN? 58:62) : 52)
#define Grid_Cell_H (INCH4_7_SCREEN_BIGGER ? (INCH4_7_SCREEN? 82: 87) : 72)

#import "AppDelegate.h"
#define RCSharedAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

//小x按钮的宽度与高度
#define Cell_DeleteBtn_W 30
#define Cell_DeleteBtn_H 30

#define SearchHeader_H 57.0


static NSString *const GridViewCellReuseIdentifier = @"GridViewCellReuseIdentifier";

static CGFloat const PRESS_TO_MOVE_MIN_DURATION = 0.25;

CG_INLINE CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
    return CGPointMake(point.x + dx, point.y + dy);
}

//获得指定view的viewController
#define UIViewParentController(__view) ({ \
    UIResponder *__responder = __view; \
    while ([__responder isKindOfClass:[UIView class]]) \
        __responder = [__responder nextResponder]; \
    (UIViewController *)__responder; \
})

#endif
