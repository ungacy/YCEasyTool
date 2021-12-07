//
//  YCChildViewController.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/21.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCChildViewController.h"
#import "YCGridView.h"

@interface YCChildViewController () <YCGridViewDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) YCGridView *gridView;

@end

@implementation YCChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
        [self.view addSubview:label];
        label.text = self.title;
        label;
    });
    NSMutableArray<NSArray *> *rowArray = [NSMutableArray array];
    NSMutableArray *columnTitleArray = [NSMutableArray array];
    NSUInteger columnCount = 10;
    NSUInteger rowCount = 30;
    [columnTitleArray addObject:@"row title"];
    for (NSUInteger column = 0; column < columnCount; column++) {
        [columnTitleArray addObject:[NSString stringWithFormat:@"col-%zd", column]];
    }
    [rowArray addObject:columnTitleArray];
    for (NSUInteger row = 0; row < rowCount; row++) {
        NSMutableArray *columnArray = [NSMutableArray array];
        [columnArray addObject:[NSString stringWithFormat:@"row-%zd", row]];
        for (NSUInteger column = 0; column < 10; column++) {
            [columnArray addObject:[NSString stringWithFormat:@"cell:%zd-%zd", row, column]];
        }
        [rowArray addObject:columnArray];
    }
    self.gridView.data = rowArray;
    self.gridView.selectionMode = YCGridViewSelectionModeNone;
    self.gridView.themeAttributes = @{
        YCGridViewLeftTitleAttributeName: @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor blackColor],
            YCGridViewBackgroundColorAttributeName: [UIColor grayColor],
            YCGridViewSeparatorStyleAttributeName: @(YCGridViewCellSeparatorStyleLineRight),
            YCGridViewSeparatorColorAttributeName: [UIColor blackColor],
        },
        YCGridViewRightTitleAttributeName: @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor blackColor],
            YCGridViewBackgroundColorAttributeName: [UIColor grayColor],
            YCGridViewSeparatorStyleAttributeName: @(YCGridViewCellSeparatorStyleLineRight),
            YCGridViewSeparatorColorAttributeName: [UIColor blackColor],
        },
        YCGridViewLeftCellAttributeName: @{
            NSFontAttributeName: [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor blackColor],
            YCGridViewBackgroundColorAttributeName: [UIColor whiteColor],
            YCGridViewSeparatorStyleAttributeName: @(YCGridViewCellSeparatorStyleLineRight),
            YCGridViewSeparatorColorAttributeName: [UIColor blackColor],
        },
        YCGridViewRightCellAttributeName: @{
            NSFontAttributeName: [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor blackColor],
            YCGridViewBackgroundColorAttributeName: [UIColor whiteColor],
            YCGridViewSeparatorStyleAttributeName: @(YCGridViewCellSeparatorStyleLineRight),
            YCGridViewSeparatorColorAttributeName: [UIColor blackColor],
        },
    };
    _gridView.extraThemeAttributes = @{
        YCGridViewColumnAttributeName: @{
            @(1): @{
                YCGridViewWidthAttributeName: @(100),
            }
        },
        YCGridViewRowAttributeName: @{
            @(1): @{
                YCGridViewWidthAttributeName: @(60),
                NSForegroundColorAttributeName: [UIColor purpleColor],
            }
        },
        YCGridViewRowAndColumnAttributeName: @{
            @"1-1": @{
                NSFontAttributeName: [UIFont systemFontOfSize:23],
            }
        },
    };
    _gridView.titleColumnWidth = 50;
    _gridView.cellColumnWidth = 80;
    _gridView.titleRowHeight = 30;
    _gridView.cellRowHeight = 50;
    _gridView.bounces = YES;
    [self.gridView reloadData];
    // Do any additional setup after loading the view.
}

- (void)gridView:(YCGridView *)gridView didSelectRow:(NSInteger)row column:(NSInteger)column data:(id)data {
    NSLog(@"did select row [%zd] column [%zd] : data [%@]", row, column, data);
}

- (YCGridView *)gridView {
    if (!_gridView) {
        _gridView = [[YCGridView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 500)];
        _gridView.delegate = self;
        [self.view addSubview:_gridView];
    }
    return _gridView;
}

@end
