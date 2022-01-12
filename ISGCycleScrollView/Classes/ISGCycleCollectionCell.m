//
//  ISGCycleCollectionCell.m
//  Pods-ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/2.
//

#import "ISGCycleCollectionCell.h"
#import "SDAutoLayout.h"

@interface ISGCycleCollectionCell()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation ISGCycleCollectionCell

#pragma mark - —————————————————————Life Cycle—————————————————————
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.toolbar.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

#pragma mark - —————————————————————Public Method—————————————————————
- (void)setBlackTranslucentMasking:(CGFloat)alpha {
    self.toolbar.alpha = alpha;
    self.toolbar.hidden = NO;
}

#pragma mark - —————————————————————Lazy Method—————————————————————
- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIToolbar *)toolbar {
    if (nil == _toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        [self.imageView addSubview:_toolbar];
        _toolbar.barStyle = UIBarStyleBlack;
        _toolbar.hidden = YES;
    }
    return _toolbar;
}
@end
