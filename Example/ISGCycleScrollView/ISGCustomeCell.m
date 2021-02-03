//
//  ISGCustomeCell.m
//  ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/3.
//  Copyright © 2021 isaaclzg. All rights reserved.
//

#import "ISGCustomeCell.h"

@implementation ISGCustomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.redColor;
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.titleLabel.textColor = UIColor.greenColor;
        self.titleLabel.frame = self.contentView.bounds;
    }
    return self;
}

@end
