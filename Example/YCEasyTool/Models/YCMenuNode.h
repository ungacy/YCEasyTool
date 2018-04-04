//
//  YCMenuNode.h
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/13.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCTreeMenuProtocol.h"
#import <Foundation/Foundation.h>

@interface YCMenuNode : NSObject <YCTreeMenuNodeProtocol>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, weak) id<YCTreeMenuNodeProtocol> parent;

@property (nonatomic, strong) NSArray<id<YCTreeMenuNodeProtocol>> *children;

@property (nonatomic, assign) BOOL expanded;

@property (nonatomic, assign) NSUInteger depth;

- (UIImage *)shrinkedImage;

- (UIImage *)expandedImage;

- (UIImage *)noChildImage;

@end
