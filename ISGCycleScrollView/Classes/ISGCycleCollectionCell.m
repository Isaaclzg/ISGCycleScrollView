//
//  ISGCycleCollectionCell.m
//  Pods-ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/2.
//

#import "ISGCycleCollectionCell.h"
@import SDAutoLayout;

@interface ISGCycleCollectionCell()

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
}

#pragma mark - —————————————————————Lazy Method—————————————————————
- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
@end
