
//
//  YCForever.m
//  YCEasyTool
//
//  Created by YeTao on 2016/12/20.
//  Copyright © 2016年 ungacy. All rights reserved.
//

#import "YCForever.h"
#import "YCForeverDAO.h"
#import "YCProperty.h"

static NSString *const kYCFDBFileName = @"forever.sqlite";

@interface YCForever ()

@end

@implementation YCForever

+ (void)setupWithPath:(NSString *)path {
    [YCForeverDAO setupWithPath:path];
}

+ (void)setupWithName:(NSString *)name {
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dir = [cacheFolder stringByAppendingPathComponent:name];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    NSString *path = [dir stringByAppendingPathComponent:kYCFDBFileName];
    [YCForeverDAO setupWithPath:path];
}

+ (void)close {
    [YCForeverDAO close];
}

@end
