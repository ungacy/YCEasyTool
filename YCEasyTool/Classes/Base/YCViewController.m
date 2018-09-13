//
//  YCViewController.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/3/27.
//  Copyright © 2017年 ungacy. All rights reserved.
//

#import "YCViewController.h"
#import <Masonry/Masonry.h>

@interface YCViewController ()

@property (nonatomic, strong) YCNavigationBar *naviBar;

@property (nonatomic, assign) BOOL si_viewAppeared;

@property (nonatomic, assign) BOOL startedNetworkActivity;

@end

@implementation YCViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
        self.customNetworkActivity = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.si_viewAppeared = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self defaultUI];
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager manager];
    __weak __typeof__(self) weak_self = self;
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weak_self reachabilityHandler:status];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_reloadWhenAppear) {
        [self loadData];
    }
    if (_hideNavigationBarLine) {
        [self showNavigationBarLine:NO];
    }
}

- (void)showNavigationBarLine:(BOOL)show {
    UIImageView *line = self.navigationController.navigationBar.subviews.firstObject.subviews.firstObject;
    line.hidden = !show;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    if (_hideNavigationBarLine) {
        [self showNavigationBarLine:YES];
    }
}

- (void)loadData {
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backward:(NSUInteger)level {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > level) {
        UIViewController *target = viewControllers[viewControllers.count - level - 1];
        [self.navigationController popToViewController:target animated:YES];
    }
}

#pragma mark Did Set

- (void)setReloadWhenAppear:(BOOL)reloadWhenAppear {
    if (reloadWhenAppear == _reloadWhenAppear) {
        return;
    }
    _reloadWhenAppear = reloadWhenAppear;
    if (!_reloadWhenAppear) {
        [self loadData];
    }
}

- (void)setHideNavigationBarLine:(BOOL)hideNavigationBarLine {
    _hideNavigationBarLine = hideNavigationBarLine;
    [self showNavigationBarLine:!hideNavigationBarLine];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
