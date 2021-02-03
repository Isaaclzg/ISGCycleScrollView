//
//  ISGCustomeViewController.m
//  ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/3.
//  Copyright © 2021 isaaclzg. All rights reserved.
//

#import "ISGCustomeViewController.h"
#import <ISGCycleScrollView.h>
#import "ISGCustomeCell.h"

@interface ISGCustomeViewController ()<ISGCycleScrollViewDataSource,ISGCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *bannerDatas;

@property (nonatomic, weak) ISGCycleScrollView *banner;

@end

@implementation ISGCustomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    ISGCycleScrollView *banner = [[ISGCycleScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [self.view addSubview:banner];
    banner.dataSource = self;
    banner.delegate = self;
    banner.scrollDirection = UICollectionViewScrollDirectionVertical;
    banner.autoScrollTimeInterval = 2.0f;
    banner.showPageControl = NO;
    self.banner = banner;
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:refreshBtn];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(0, 400, 200, 60);
    [refreshBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [refreshBtn addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - —————————————————————Event Method—————————————————————
- (void)didRefresh:(id)sender {
    [self.bannerDatas removeAllObjects];
    [self.bannerDatas addObjectsFromArray:@[@"aaaaaaaaaaaa",@"bbbbbbbbbbbb",@"cccccccccccc"]];
    [self.banner reloadData];
}

#pragma mark - —————————————————————ISGCycleScrollViewDelegate—————————————————————
- (void)cycleScrollView:(ISGCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"-----%ld----",index);
}

#pragma mark - —————————————————————ISGCycleScrollViewDataSource—————————————————————
- (Class)customCollectionViewCellClassForCycleScrollView:(ISGCycleScrollView *)view {
    return [ISGCustomeCell class];
}

- (NSInteger)numberOfItems {
    return self.bannerDatas.count;
}

- (NSArray *)datas {
    return self.bannerDatas.copy;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ISGCustomeCell *cell = (ISGCustomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ISGCustomeCell class]) forIndexPath:indexPath];
    if (self.bannerDatas.count > 0) {
        cell.titleLabel.text = self.bannerDatas[indexPath.item];
    }
    return cell;
}

#pragma mark - —————————————————————Lazy Method—————————————————————
- (NSArray *)titles {
    return @[@"标题11111111111111111",@"标题2222222222222",@"标题3333333333333333"];
}

- (NSMutableArray *)bannerDatas {
    if (nil == _bannerDatas) {
        _bannerDatas = [NSMutableArray array];
        [_bannerDatas addObjectsFromArray:[self titles]];
    }
    return _bannerDatas;
}
@end
