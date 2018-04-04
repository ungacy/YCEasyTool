//
//  YCDemoViewController.m
//  YCEasyTool
//
//  Created by Ye Tao on 01/23/2017.
//  Copyright (c) 2017 Ye Tao. All rights reserved.
//

#import "YCDemoViewController.h"
#import "NSArray+YCTools.h"
#import "YCDemoModel.h"
#import "YCForever.h"
#import "YCMenuCell.h"
#import "YCMenuNode.h"
#import "YCSegmentedControl.h"
#import "YCTreeMenuView.h"

@interface YCDemoViewController () <YCTreeMenuViewDelegate>

@property (nonatomic, strong) YCTreeMenuView *menu;

@property (nonatomic, strong) YCSegmentedControl *segment;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation YCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    BOOL testDB = YES;
    if (testDB) {
        [self setupDB];
        [self addItem2DB];
        [self query];
        [self clear];
        [self remove];
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL testUI = YES;
    if (testUI) {
        [self setupMenu];
        [self setupSegment];
    }
}

- (NSArray *)nodeArrayWithCount:(NSUInteger)count parent:(YCMenuNode *)parent {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSUInteger index = 0; index < count; index++) {
        YCMenuNode *node = [[YCMenuNode alloc] init];
        if (parent) {
            node.title = [NSString stringWithFormat:@"%@-%zd", parent.title, index];
        } else {
            node.title = [NSString stringWithFormat:@"%zd", index];
        }
        node.parent = parent;
        [array addObject:node];
    }
    return array;
}

- (void)setupMenu {
    NSArray *array = [self nodeArrayWithCount:5 parent:nil];
    [array enumerateObjectsUsingBlock:^(YCMenuNode *_Nonnull sub1,
                                        NSUInteger idx,
                                        BOOL *_Nonnull stop) {
        sub1.children = [self nodeArrayWithCount:idx + 1 parent:sub1];
        [sub1.children enumerateObjectsUsingBlock:^(id<YCTreeMenuNodeProtocol> _Nonnull sub2,
                                                    NSUInteger idx2,
                                                    BOOL *_Nonnull stop) {
            sub2.children = [self nodeArrayWithCount:idx2 + 1 parent:sub2];
        }];
    }];
    CGRect frame = self.view.bounds;
    self.menu = [[YCTreeMenuView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 2, frame.size.height)];
    [self.view addSubview:self.menu];
    self.menu.delegate = self;
    [self.menu registerMenuCell:[YCMenuCell class]];
    [self.menu reloadData:array];
    self.menuArray = array;
    self.button = ({
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(frame.size.width / 2, frame.size.height / 2, frame.size.width / 2, 24);
        [self.view addSubview:button];
        button.backgroundColor = [UIColor grayColor];
        [button setTitle:@"No item was selected" forState:UIControlStateNormal];
        [button addTarget:self
                      action:@selector(action)
            forControlEvents:UIControlEventTouchUpInside];
        button;
    });
}

- (void)action {
    YCPopMenu *pop = [YCPopMenu popMenuWithCellClass:[YCMenuCell class]
                                           dataArray:@[@"1", @"2", @"3"]
                                         actionBlock:^(NSUInteger index, id data) {
                                             [self.button setTitle:[data description] forState:UIControlStateNormal];
                                         }];
    pop.vector = CGVectorMake(0, 0);
    [pop setDirection:(YCPopMenuDirection)[[self.button titleForState:UIControlStateNormal] intValue] % 2];
    [pop showFromView:self.button];
}

- (void)treeMenu:(YCTreeMenuView *)treeMenuView didSelectNode:(id<YCTreeMenuNodeProtocol>)node {
    [self.button setTitle:node.title forState:UIControlStateNormal];
}

- (void)treeMenu:(YCTreeMenuView *)treeMenuView didChangeNode:(id<YCTreeMenuNodeProtocol>)node {
}

- (void)setupSegment {
    self.segment = ({
        CGRect bounds = self.view.bounds;
        CGRect frame = CGRectMake((bounds.size.width - 256) / 2, 64, 256, 24);
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        [items addObject:[[YCSegmentItem alloc] initWithTitle:@"亢龙有悔" icon:nil]];
        [items addObject:[[YCSegmentItem alloc] initWithTitle:@"飞龙在天" icon:nil]];
        YCSegmentedControl *segment = [[YCSegmentedControl alloc] initWithFrame:frame
                                                                          items:items
                                                                 selectionBlock:^(NSUInteger segmentIndex){

                                                                 }];
        self.navigationItem.titleView = segment;
        segment.textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                   NSForegroundColorAttributeName: [UIColor blackColor]};
        segment.selectedTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor whiteColor]};
        segment.borderColor = [UIColor grayColor];
        segment.color = [UIColor whiteColor];
        segment.borderWidth = 1;
        segment.selectedColor = [UIColor blackColor];
        segment.cornerRadius = 2;
        [segment setSelected:YES segmentAtIndex:0];
        segment;
    });
}

- (void)setupDB {
    [YCForever setupWithName:@"test"];
}

- (void)query {
    YCDemoModel *demo = [[YCDemoModel alloc] init];
    demo.bool_tag = YES;
    NSArray<YCDemoModel *> *array = YCDemoModel.ycf.limit(10).offset(0).order(@"int16_t_tag asc").where(@"'int16_t_tag' > 3").query();
    NSLog(@"%zd", array.count);
    [array yc_each:^(YCDemoModel *obj) {
        NSLog(@"'int16_t_tag' > 3 uuid : %@", obj.uuid);
    }];

    NSArray *custom = YCDemoModel.ycf.sql(@"SELECT * FROM YCDemoModel WHERE \"bool_tag\" = 0  ORDER BY long_double_tag DESC LIMIT 10 OFFSET 3").query();
    [custom yc_each:^(YCDemoModel *obj) {
        NSLog(@"custom uuid : %@", obj.uuid);
    }];
}

- (void)addItem2DB {
    YCDemoModel.ycf.remove();
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger index = 0; index < 10; index++) {
        YCDemoModel *demo = [[YCDemoModel alloc] init];
        //test for overflow
        double value = index * 1.0;
        demo.id_p = index;
        demo.bool_tag = (bool)(index % 2);
        demo.int16_t_tag = arc4random() & 10000;
        //        demo.int8_t_tag = INT8_MIN;
        //        demo.uint8_t_tag = UINT8_MAX;
        //        demo.int16_t_tag = INT16_MIN;
        //        demo.uint16_t_tag = UINT16_MAX;
        //        demo.int32_t_tag = INT32_MIN;
        //        demo.uint32_t_tag = UINT32_MAX;
        //        demo.int64_t_tag = INT64_MIN;
        //        demo.uint64_t_tag = UINT64_MAX;
        //        demo.float_tag = FLT_MAX;
        //        demo.double_tag = CGFLOAT_MAX;
        demo.long_double_tag = value;
        demo.uuid = [NSString stringWithFormat:@"uuid%d", demo.int16_t_tag];
        demo.name = [NSString stringWithFormat:@"name%.f", value];
        [array addObject:demo];
    }
    array.ycf.save();
}

- (void)remove {
    YCDemoModel *demo = [[YCDemoModel alloc] init];
    demo.uuid = @"ungacy";
    demo.ycf.load();
    YCDemoModel.ycf.query();

    YCDemoModel.ycf.where(@"where id_p % 5 == 0").remove();
    demo.ycf.where(@"where id_p = 4").update();
    demo.ycf.where(@"where id_p = 3").update();
    //    YCDemoModel.ycf.remove();
}

- (void)clear {
    //    YCDemoModel.ycf.truncate();
    //[YCForever close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
