//
//  YCMenuNode.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/13.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCMenuNode.h"

@implementation YCMenuNode

- (CGFloat)height {
    return 40;
}

- (UIImage *)shrinkedImage {
    return [UIImage imageNamed:@"menu_add"];
}

- (UIImage *)expandedImage {
    return [UIImage imageNamed:@"menu_minus"];
}

- (UIImage *)noChildImage {
    return [UIImage imageNamed:@"menu_empty"];
}

@end
