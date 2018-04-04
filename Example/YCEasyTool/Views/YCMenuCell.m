//
//  YCMenuCell.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/13.
//  Copyright © 2017年 Ye Tao. All rights reserved.
//

#import "YCMenuCell.h"
#import "YCMenuNode.h"

@interface YCMenuCell ()

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) YCMenuNode *node;

@end

@implementation YCMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.actionButton = ({
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(20, 10, 20, 20);
        button;
    });

    self.title = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
        [self.contentView addSubview:label];
        label;
    });
}

static inline CGRect CGRectXOffset(CGRect rect, CGFloat xOffset) {
    rect.origin.x = xOffset;
    return rect;
}

- (void)reloadWithData:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.title.text = data;
        self.title.frame = CGRectMake(0, 0, 50, 40);
        [self.actionButton removeFromSuperview];
        self.actionButton = nil;
    }
}

+ (CGSize)menuSize {
    return CGSizeMake(100, 40);
}

- (void)reloadData:(id<YCTreeMenuNodeProtocol>)node {
    self.node = node;
    self.title.text = node.title;
    CGFloat xOffset = 20 * (node.depth + 1);
    self.actionButton.frame = CGRectXOffset(self.actionButton.frame, xOffset);
    self.title.frame = CGRectXOffset(self.title.frame, xOffset + 30);
    [self reloadIcon];
}

- (void)reloadIcon {
    UIImage *icon;
    if (self.node.children) {
        icon = self.node.expanded ? [self.node expandedImage] : [self.node shrinkedImage];
    } else {
        icon = [self.node noChildImage];
    }
    [self.actionButton setImage:icon forState:UIControlStateNormal];
}

- (void)action {
    if (self.actionBlock) {
        self.actionBlock();
    }
    [self reloadIcon];
}

@end
