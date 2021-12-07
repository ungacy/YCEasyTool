//
//  YCDemoTabBarController.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/21.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCDemoTabBarController.h"
#import "YCChildViewController.h"
#import "YCDemoViewController.h"
#import "YCMenuCell.h"
#import "YCPopMenu.h"
#import "YCTabBarItem.h"
#import "NSArray+YCTools.h"

@interface YCDemoTabBarController () <YCTabBarControllerDelegate>

@property (nonatomic, strong) NSArray *titles;

@end

@implementation YCDemoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    NSArray<NSString *> *titles = @[@"TreeMenu", @"Tab0", @"Tab1", @"Tab2", @"More0", @"More1", @"More2"];
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:0];
    self.maxCount = 5;
    {
        YCDemoViewController *demo = [[YCDemoViewController alloc] init];
        demo.title = titles[0];
        UIViewController *navigationController = [[UINavigationController alloc]
            initWithRootViewController:demo];
        [children addObject:navigationController];
    }

    titles.yc_forEach(^(NSUInteger idx, NSString *obj) {
        YCChildViewController *viewController = [[YCChildViewController alloc] init];
        viewController.title = obj;
        UIViewController *navigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:viewController];
        [children addObject:navigationController];
    });
    children = titles.yc_map(^id(NSUInteger idx, NSString * obj) {
        YCChildViewController *viewController = [[YCChildViewController alloc] init];
        viewController.title = obj;
        UIViewController *navigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:viewController];
        return navigationController;
    });
    
    [self setViewControllers:children];
    self.titles = titles;
}

- (void)tabBarController:(YCTabBarController *)tabBarController didSelectMoreWithBlock:(YCTabBarControllerMoreBlock)block {
    NSUInteger maxCount = tabBarController.maxCount - 1;
    NSArray *moreArray = [self.titles subarrayWithRange:NSMakeRange(maxCount, self.titles.count - maxCount)];

    YCPopMenu *menu = [YCPopMenu popMenuWithCellClass:[YCMenuCell class]
                                            dataArray:moreArray
                                          actionBlock:^(NSUInteger index, id data) {
                                              if (index != YCPopMenuNoSelectionIndex) {
                                                  block(index + maxCount);
                                              }
                                          }];
    menu.vector = CGVectorMake(-150, -50);
    //    [menu setCoverColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [menu showFromView:tabBarController.tabBar.items[maxCount]];
    menu.shadow = NO;
    if (menu) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"More"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [moreArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           block(idx + maxCount);
                                                       }];
        [alert addAction:action];
    }];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
