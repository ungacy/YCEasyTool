//
//  YCTableViewController.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/3/28.
//  Copyright © 2017年 ungacy. All rights reserved.
//

#import "YCTableViewController.h"
#import <Masonry/Masonry.h>
#import <YCEasyTool/YCPollingEntity.h>

@interface YCTableViewController () <UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *cellIdentifierArray;

@property (nonatomic, assign) UITableViewStyle style;

@property (nonatomic, strong) YCEmptyView *emptyView;

@property (nonatomic, strong) YCPollingEntity *polling;

@property (nonatomic, assign) CGFloat pollingDuration;

@property (nonatomic, copy) NSString *keyword;

@end

@implementation YCTableViewController {
    BOOL _emptyFlag;
    BOOL _footerFlag;
    BOOL _registerFlag;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        _cellHeight = kYCBaseTableViewDefaultCellHeight;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}

- (void)loadMoreData {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [YCColor whiteColor];
    self.emptyTheme = @{kYCEmptyViewThemeIcon: @"ic_no_content",
                        kYCEmptyViewThemeTitle: @"无数据"};
    //data source
    _section = _section ?: @[kYCSingleSectionKey];
    _dataSource = [@{} mutableCopy];

    //table view style
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.backgroundColor = [YCColor whiteColor];
    YCRefreshHeader *header = [YCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshAction)];
    self.tableView.mj_header = header;
    self.pollingDuration = 0.3;
}

- (void)_refreshAction {
    [self loadData];
}

- (void)reachabilityHandler:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusNotReachable) {
        if (self->_emptyView) {
            [self.emptyView reloadWithData:@(YCEmptyViewTypeNoNetWork)];
        }
    } else {
        [self loadData];
    }
}

#pragma mark - Cell

- (void)setCellClass:(Class)cellClass {
    _registerFlag = _tableView != nil;
    _cellClass = cellClass;
    [_tableView registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)setCellClassArray:(NSArray<Class> *)cellClassArray {
    NSMutableArray *cellIdentifierArray = [NSMutableArray array];
    [cellClassArray enumerateObjectsUsingBlock:^(Class _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self setCellClass:obj];
        [cellIdentifierArray addObject:NSStringFromClass(obj)];
    }];
    _cellClassArray = cellClassArray;
    _cellIdentifierArray = cellIdentifierArray;
}

#pragma mark - Refresh

- (void)setPullToRefresh:(BOOL)pullToRefresh {
    _pullToRefresh = pullToRefresh;
    if (_pullToRefresh) {
        if (self.tableView.mj_header) {
            return;
        }
        YCRefreshHeader *header = [YCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshAction)];
        self.tableView.mj_header = header;
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setPullToLoadMore:(BOOL)pullToLoadMore {
    _pullToLoadMore = pullToLoadMore;
    if (_pullToLoadMore) {
        if (self.tableView.mj_footer) {
            return;
        }
        self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    } else {
        self.tableView.mj_footer = nil;
    }
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    if (self.section.count <= indexPath.section) {
        return nil;
    }
    NSString *key = self.section[indexPath.section];
    NSArray *cellArray = self.dataSource[key];
    if (cellArray.count <= indexPath.row) {
        return nil;
    }
    return cellArray[indexPath.row];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSUInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSUInteger)section {
    return 0.0001;
}

- (NSUInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    YCRefreshHeader *header = (YCRefreshHeader *)self.tableView.mj_header;
    [header finish];
    if (!self.section) {
        tableView.backgroundView = self.emptyView;
        [self.emptyView reloadWithData:@(YCEmptyViewTypeNoData)];
        return 0;
    }
    if ([self.section containsObject:kYCNoPermossionKey]) {
        tableView.backgroundView = self.emptyView;
        [self.emptyView reloadWithData:@(YCEmptyViewTypeNoPermission)];
        return 0;
    }
    if ([tableView.backgroundView isKindOfClass:[YCEmptyView class]]) {
        tableView.backgroundView = nil;
    }
    NSUInteger count = self.section.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<YCFormItemProtocol> item = [self objectAtIndexPath:indexPath];
    if ([item respondsToSelector:@selector(height)]) {
        return item.height > 0 ? item.height : _cellHeight;
    }
    return _cellHeight;
}

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSUInteger)section {
    YCRefreshHeader *header = (YCRefreshHeader *)self.tableView.mj_header;
    [header finish];
    [self.tableView.mj_footer endRefreshing];
    if (self.section.count <= section) {
        return 0;
    }
    return self.dataSource[self.section[section]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    id<YCFormItemProtocol> data = [self objectAtIndexPath:indexPath];
    if (self.reuseIdentifierBlock) {
        identifier = self.reuseIdentifierBlock(indexPath);
    } else {
        if ([data respondsToSelector:@selector(identifier)] && [data identifier]) {
            identifier = [data identifier];
        } else {
            identifier = NSStringFromClass(self.cellClass);
        }
    }
    UITableViewCell<YCDataBindProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //NSParameterAssert(cell);
    return cell ?: [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell<YCDataBindProtocol> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(actionBlock)]) {
        __weak __typeof__(self) weak_self = self;
        [cell setActionBlock:^(id action) {
            if ([action isKindOfClass:[NSString class]] &&
                [action isEqualToString:kYCDataBindReloadAction]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                return;
            }
            [weak_self action:action atIndexPath:indexPath];
        }];
    }
    if ([cell respondsToSelector:@selector(reloadWithData:)]) {
        id<YCFormItemProtocol> data = [self objectAtIndexPath:indexPath];
        [cell reloadWithData:data];
        if ([cell respondsToSelector:@selector(bottomLine)]) {
            UIView *line = [cell valueForKey:@"_bottomLine"];
            if ([data respondsToSelector:@selector(theme)]) {
                NSDictionary *theme = data.theme;
                line.hidden = [theme[kYCFormItemThemeLast] boolValue];
            }
        }
    }
}

- (void)action:(id)action atIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self action:nil atIndexPath:indexPath];
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    if (animation == UITableViewRowAnimationNone) {
        UITableViewCell<YCDataBindProtocol> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell reloadWithData:[self objectAtIndexPath:indexPath]];
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    if (self.section.count <= indexPath.section) {
        return;
    }
    NSString *key = self.section[indexPath.section];
    NSMutableArray *cellArray = (NSMutableArray *)self.dataSource[key];
    if (cellArray.count <= indexPath.row) {
        return;
    }
    if ([cellArray isKindOfClass:[NSMutableArray class]]) {
        [cellArray removeObjectAtIndex:indexPath.row];
    } else if ([cellArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableCellArray = [cellArray mutableCopy];
        [mutableCellArray removeObjectAtIndex:indexPath.row];
        self.dataSource[key] = mutableCellArray;
    }
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.pollingDuration == 0) {
        self.keyword = searchController.searchBar.text;
        [self searchWithKeyword:self.keyword];
        return;
    }
    [self.polling stopRunning];
    __weak __typeof__(self) weak_self = self;
    [self.polling startRunningWithBlock:^(NSTimeInterval current) {
        weak_self.keyword = searchController.searchBar.text;
        [weak_self searchWithKeyword:weak_self.keyword];
    }];
}

#pragma mark - Did Set

- (void)setCustomNaviBar:(BOOL)customNaviBar {
    [super setCustomNaviBar:customNaviBar];
    if (customNaviBar) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset([[UIApplication sharedApplication] statusBarFrame].size.height + 44);
        }];
    }
}

- (void)setEmptyTheme:(NSDictionary *)emptyTheme {
    _emptyTheme = [emptyTheme copy];
    _emptyView.theme = [emptyTheme copy];
}

#pragma mark - Lazy Load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        if (_style == UITableViewStyleGrouped) {
            _tableView.sectionFooterHeight = 0;
            _tableView.sectionHeaderHeight = 0;
        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        if (!_registerFlag) {
            if (self.cellClassArray) {
                self.cellClassArray = self.cellClassArray;
            } else if (self.cellClass) {
                self.cellClass = self.cellClass;
            }
        }
    }
    return _tableView;
}

- (YCEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [YCEmptyView new];
        __weak __typeof__(self) weak_self = self;
        _emptyView.actionBlock = ^(id data) {
            [weak_self loadData];
        };
    }
    _emptyView.frame = self.tableView.bounds;
    _emptyView.theme = self.emptyTheme;
    return _emptyView;
}

- (YCPollingEntity *)polling {
    if (!_polling) {
        _polling = [YCPollingEntity pollingEntityWithTimeInterval:self.pollingDuration max:self.pollingDuration];
    }
    return _polling;
}

@end

@implementation YCViewController (YCSearch)

- (UISearchController *)searchControllerWithResults:(YCViewController *)results {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:results];
    searchController.searchResultsUpdater = (id)self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.searchBar.placeholder = @"搜索";
    //searchController.searchBar.barTintColor = [YCColor colorWithHex:0xe9e9e9];
    for (UIView *view in searchController.searchBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIView *background = [[UIView alloc] init];
            [view addSubview:background];
            background.backgroundColor = [YCColor colorWithHex:0xe9e9e9];
            [background mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(view);
            }];
            break;
        }
    }
    //self.definesPresentationContext = YES;
    searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 36);
    [searchController.searchBar sizeToFit];
    searchController.delegate = (id)self;
    searchController.searchBar.delegate = (id)self;
    return searchController;
}

- (void)searchWithKeyword:(NSString *)keyword {
}

@end
