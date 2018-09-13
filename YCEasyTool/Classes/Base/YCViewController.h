//
//  YCViewController.h
//  YCEasyTool
//
//  Created by Ye Tao on 2017/3/27.
//  Copyright © 2017年 ungacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCViewController <NSObject>

/**
 just pop `1` level back
 */
- (void)goBack;

/**
 backward `level` level back

 @param level 往前跳的级数
 */
- (void)backward:(NSUInteger)level;

- (void)loadData;

@end

@interface YCViewController : UIViewController <YCViewController>

@property (nonatomic, assign) BOOL reloadWhenAppear;

@property (nonatomic, assign) BOOL hideNavigationBarLine;


@end

