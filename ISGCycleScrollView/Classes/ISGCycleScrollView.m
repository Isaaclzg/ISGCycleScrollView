//
//  ISGCycleScrollView.m
//  Pods-ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/2.
//

#import "ISGCycleScrollView.h"
#import "ISGCycleCollectionCell.h"
#import "SDAutoLayout.h"
#import "TAPageControl.h"
#import "TAAnimatedDotView.h"
#import "UIImageView+WebCache.h"

static NSString * const ISGCycleCollectionCellID  = @"ISGCycleCollectionCellID";

@interface ISGCycleScrollView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, strong) NSArray *imagePathsGroup;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger totalItemsCount;

/// 当imageURLs为空时的背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;

/// 黑色半透明度
@property (nonatomic, assign) CGFloat blackTranslucentMaskingAlpha;

@end

@implementation ISGCycleScrollView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self initialization];
    
}

- (void)initialization {
    self.autoScrollTimeInterval = 5.0;
    self.infiniteLoop = YES;
    self.autoScroll = YES;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.imageViewContentMode = UIViewContentModeScaleToFill;
    self.showPageControl = YES;
    self.hidesForSinglePage = YES;
    self.pageControlStyle = PageControlStyleSystemClassics;
    self.pageControlAliment = PageControlAlignmentCenter;
    self.pageControlDotSize = CGSizeMake(10, 10);
    self.currentPageDotColor = UIColor.whiteColor;
    self.pageDotColor = UIColor.lightGrayColor;
    self.pageControlBottomOffset = 0;
    self.pageControlRightOffset = 0;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupPageControl {
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    if (self.imagePathsGroup.count == 0) {
        return;
    }
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) {
        return;
    }
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (self.pageControlStyle) {
        case PageControlStyleAnimated:
        {
            TAPageControl *pageControl = [[TAPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            if ([pageControl.dotViewClass isKindOfClass:[TAAnimatedDotView class]]) {
                TAAnimatedDotView *animatedDotView = (TAAnimatedDotView *)pageControl.dotViewClass;
                animatedDotView.layer.borderColor = self.currentPageDotColor.CGColor;
            }
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
        }
            break;
            
        case PageControlStyleSystemClassics:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
        }
            break;
            
        default:
            break;
    }
    
    // 重设pagecontrol dot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.frame = self.bounds;
    if (self.collectionView.contentOffset.x == 0 && self.totalItemsCount) {
        NSInteger targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = self.totalItemsCount * 0.5;
        }else {
            targetIndex = 0;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(CGSizeMake(10, 10), self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
    } else {
        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
        // ios14 需要按照系统规则适配pageControl size
        if (@available(iOS 14.0, *)) {
            if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
                UIPageControl *pageControl = (UIPageControl *)self.pageControl;
                size.width = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count].width;
            }
        }
    }
    
    CGFloat x = (self.width - size.width) * 0.5;
    if (self.pageControlAliment == PageControlAlignmentRight) {
        x = self.collectionView.width - size.width - 10;
    }
    CGFloat y = self.collectionView.height - size.height - 10;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !self.showPageControl;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}

#pragma mark - —————————————————————UICollectionViewDataSource—————————————————————
#pragma mark - 返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - 每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItems)]) {
        return self.totalItemsCount;
    }
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(collectionView: cellForItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
    }
    ISGCycleCollectionCell *cell = (ISGCycleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ISGCycleCollectionCellID forIndexPath:indexPath];
    
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    if ([imagePath hasPrefix:@"http"]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
    } else {
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        cell.imageView.image = image;
    }
    if (self.blackTranslucentMaskingAlpha > 0) {
        [cell setBlackTranslucentMasking:self.blackTranslucentMaskingAlpha];
    }
    cell.imageView.contentMode = self.imageViewContentMode;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView: didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.didSelectAtInex) {
        self.didSelectAtInex([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - —————————————————————UIScrollViewDelegate—————————————————————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) {
        return ;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) {
        return ;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
    if (self.didScrollAtIndex) {
        self.didScrollAtIndex(indexOnPageControl);
    }
}

#pragma mark - —————————————————————Public Method—————————————————————
- (void)adjustWhenControllerViewWillAppear {
    long targetIndex = [self currentIndex];
    if (targetIndex < self.totalItemsCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == self.totalItemsCount) {
        return ;
    }
    [self scrollToIndex:self.totalItemsCount * 0.5 + index];
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)reloadData {
    self.imagePathsGroup = [[self.dataSource datas] copy];
    NSLog(@"");
}

- (void)setBlackTranslucentMasking:(CGFloat)alpha {
    self.blackTranslucentMaskingAlpha = alpha;
    [self.collectionView reloadData];
}

#pragma mark - —————————————————————Private Method—————————————————————
- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return index % self.imagePathsGroup.count;
}

- (NSInteger)currentIndex {
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot {
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setupTimer {
    // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    [self invalidateTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)automaticScroll {
    if (0 == self.totalItemsCount) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex {
    if (targetIndex >= self.totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = self.totalItemsCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - —————————————————————Setter Method—————————————————————
- (void)setDelegate:(id<ISGCycleScrollViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setDataSource:(id<ISGCycleScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    if ([dataSource respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)]) {
        [self.collectionView registerClass:[self.dataSource customCollectionViewCellClassForCycleScrollView:self] forCellWithReuseIdentifier:NSStringFromClass([self.dataSource customCollectionViewCellClassForCycleScrollView:self])];
    }
    
    self.imagePathsGroup = [[dataSource datas] copy];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    _imagePathsGroup = imagePathsGroup;
    
    [self invalidateTimer];
    self.totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    // 由于 !=1 包含count == 0等情况
    if (imagePathsGroup.count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.collectionView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    [self setupPageControl];
    [self.collectionView reloadData];
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    if (autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = scrollDirection;
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    _imageViewContentMode = imageViewContentMode;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = self.imageViewContentMode;
        [self insertSubview:bgImageView belowSubview:self.collectionView];
        self.backgroundImageView = bgImageView;
    }
    self.backgroundImageView.image = placeholderImage;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    
    self.pageControl.hidden = !showPageControl;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
}

- (void)setPageControlStyle:(ISGPageControlStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
    
    [self setupPageControl];
}

- (void)setPageControlAliment:(ISGPageControlAlignment)pageControlAliment {
    _pageControlAliment = pageControlAliment;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageContol = (TAPageControl *)self.pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        if ([pageControl.dotViewClass isKindOfClass:[TAAnimatedDotView class]]) {
            TAAnimatedDotView *animatedDotView = (TAAnimatedDotView *)pageControl.dotViewClass;
            animatedDotView.layer.borderColor = currentPageDotColor.CGColor;
        }
    } else {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }

}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    
    if (self.pageControlStyle != PageControlStyleAnimated) {
        self.pageControlStyle = PageControlStyleAnimated;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage {
    _pageDotImage = pageDotImage;
    
    if (self.pageControlStyle != PageControlStyleAnimated) {
        self.pageControlStyle = PageControlStyleAnimated;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setPageControlBottomOffset:(CGFloat)pageControlBottomOffset {
    _pageControlBottomOffset = pageControlBottomOffset;
}

- (void)setPageControlRightOffset:(CGFloat)pageControlRightOffset {
    _pageControlRightOffset = pageControlRightOffset;
}

#pragma mark - —————————————————————Lazy Method—————————————————————
- (UICollectionViewFlowLayout *)flowLayout {
    if (nil == _flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ISGCycleCollectionCell class] forCellWithReuseIdentifier:ISGCycleCollectionCellID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

#pragma mark - —————————————————————dealloc—————————————————————
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}
@end
