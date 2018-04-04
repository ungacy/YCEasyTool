//
//  YCMenuCell.h
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/13.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCPopMenu.h"
#import "YCTreeMenuProtocol.h"
#import <UIKit/UIKit.h>

@interface YCMenuCell : UITableViewCell <YCTreeMenuCellProtocol, YCPopMenuCellProtocol>

- (void)reloadData:(id<YCTreeMenuNodeProtocol>)node;

@property (nonatomic, copy) YCTreeMenuCellActionBlock actionBlock;

@end
