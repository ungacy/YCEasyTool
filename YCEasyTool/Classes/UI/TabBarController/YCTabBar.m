//
//  YCTabBar.m
//  YCEasyTool
//
//  Created by Ye Tao on 2017/2/21.
//
//

#import "YCTabBar.h"
#import "YCTabBarItem.h"

@interface YCTabBar ()

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) UIScrollView *backgroundView;

@end

@implementation YCTabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    UIScrollView *backgroundView = [[UIScrollView alloc] init];
    backgroundView.bounces = NO;
    backgroundView.showsHorizontalScrollIndicator = NO;
    _backgroundView = backgroundView;
    [self addSubview:_backgroundView];
    [self setTranslucent:NO];
}

- (CGFloat)itemWidthWithCount:(NSUInteger)count {
    CGSize frameSize = [UIScreen mainScreen].bounds.size;
    return roundf((frameSize.width - [self contentEdgeInsets].left -
                   [self contentEdgeInsets].right) /
                  count);
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];

    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                               frameSize.width, frameSize.height)];

    if (self.itemWidth <= 0) {
        self.itemWidth = [self itemWidthWithCount:self.items.count];
    }

    NSInteger index = 0;

    // Layout items

    for (YCTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];

        if (!itemHeight) {
            itemHeight = frameSize.height;
        }

        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        [item setNeedsDisplay];

        index++;
    }
    [self.backgroundView setContentSize:CGSizeMake(self.itemWidth * self.items.count, frameSize.height)];
}

#pragma mark - Configuration

- (void)centerItem:(NSUInteger)index {
    if (!self.centerSelectedItem) {
        return;
    }
    NSUInteger fixedIndex = MAX(2, index);
    if (self.items.count - 3 <= index) {
        fixedIndex = self.items.count - 3;
    }
    CGFloat offset = self.contentEdgeInsets.left + self.itemWidth * (fixedIndex - 2);
    [self.backgroundView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (YCTabBarItem *item in _items) {
        [item removeFromSuperview];
    }

    _items = [items copy];
    for (YCTabBarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self.backgroundView addSubview:item];
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);

    for (YCTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }

    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    [self setSelectedItem:sender];
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(YCTabBarItem *)selectedItem {
    NSInteger index = [self.items indexOfObject:selectedItem];
    [self centerItem:index];
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;

    CGFloat alpha = (translucent ? 0.9 : 1.0);

    [_backgroundView setBackgroundColor:[UIColor colorWithRed:245 / 255.0
                                                        green:245 / 255.0
                                                         blue:245 / 255.0
                                                        alpha:alpha]];
}

@end
