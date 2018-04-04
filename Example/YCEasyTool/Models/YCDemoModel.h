//
//  YCDemoModel.h
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/7.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCForeverProtocol.h"
#import <Foundation/Foundation.h>

typedef void (^YCDemoModelBlock)(void);

@interface YCDemoModel : NSObject <YCForeverItemProtocol>

@property (nonatomic, assign) bool bool_tag;

@property (nonatomic, assign) int8_t int8_t_tag;

@property (nonatomic, assign) uint8_t uint8_t_tag;

@property (nonatomic, assign) int16_t int16_t_tag;

@property (nonatomic, assign) uint16_t uint16_t_tag;

@property (nonatomic, assign) int32_t int32_t_tag;

@property (nonatomic, assign) uint32_t uint32_t_tag;

@property (nonatomic, assign) int64_t int64_t_tag;

@property (nonatomic, assign) uint64_t uint64_t_tag;

@property (nonatomic, assign) float float_tag;

@property (nonatomic, assign) double double_tag;

@property (nonatomic, assign) long double long_double_tag;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, strong) YCDemoModel *model;

@property (nonatomic, strong) id object;

@property (nonatomic, assign) NSUInteger id_p;

@end
