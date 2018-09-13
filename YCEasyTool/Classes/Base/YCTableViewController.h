//
//  YCTableViewController.h
//  YCEasyTool
//
//  Created by Ye Tao on 2017/3/28.
//  Copyright © 2017年 ungacy. All rights reserved.
//

#import "YCBaseTableViewDefine.h"
#import "YCViewController.h"
#import <UIKit/UIKit.h>

@interface YCTableViewController : YCViewController <UITableViewDelegate, UITableViewDataSource>

#pragma mark - Style

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DEYCGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL pullToRefresh;

#pragma mark - Load More

@property (nonatomic, assign) BOOL pullToLoadMore;

- (void)loadMoreData;

#pragma mark - Data Source

@property (nonatomic, strong) NSArray /* <NSString *> or <NSNumber *> */ *section;

@property (nonatomic, strong) NSMutableDictionary<id, NSArray *> *dataSource;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Reuse Identifier

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, copy) NSArray<Class> *cellClassArray;

@property (nonatomic, readonly) NSArray<NSString *> *cellIdentifierArray;

@property (nonatomic, copy) NSString * (^reuseIdentifierBlock)(NSIndexPath *indexPath);

#pragma mark - Action

- (void)action:(id)action atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Empty

/**
 @{@"title":@"", @"icon":@""}
 */
@property (nonatomic, copy) NSDictionary *emptyTheme;

#pragma mark - Reload

- (void)reloadIndexPath:(NSIndexPath *)indexPath;

- (void)reloadIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Search

@property (nonatomic, copy, readonly) NSString *keyword;

@end

@interface YCViewController (YCSearch)

- (UISearchController *)searchControllerWithResults:(YCViewController *)results;

- (void)searchWithKeyword:(NSString *)keyword;

@end
