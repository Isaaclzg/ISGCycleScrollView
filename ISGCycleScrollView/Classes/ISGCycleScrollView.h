//
//  ISGCycleScrollView.h
//  Pods-ISGCycleScrollView_Example
//
//  Created by apple on 2021/2/2.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ISGPageControlAlignment) {
    PageControlAlignmentCenter = 0,
    PageControlAlignmentLeft,
    PageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, ISGPageControlStyle) {
    /*! @brief 系统经典样式 */
    PageControlStyleSystemClassics = 0,
    /*! @brief 动画效果 */
    PageControlStyleAnimated,
    /*! @brief 不显示 */
    PageControlStyleNone
};

@class ISGCycleScrollView;
@protocol ISGCycleScrollViewDelegate <NSObject>
@optional

- (void)cycleScrollView:(ISGCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end


/// 自定义视图需要实现的数据源
@protocol ISGCycleScrollViewDataSource <NSObject>

/// 自定义Cell类声明
/// @param view ISGCycleScrollView
- (Class)customCollectionViewCellClassForCycleScrollView:(ISGCycleScrollView *)view;

/// item数量
- (NSInteger)numberOfItems;

/// Cell的数据源
- (NSArray *)datas;

/// 自定义Cell 注意：Cell的ReuseIdentifier需要和Cell相同，例如UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
/// @param collectionView collectionView
/// @param indexPath indexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ISGCycleScrollView : UIView

@property (nonatomic, weak) id <ISGCycleScrollViewDelegate> delegate;

@property (nonatomic, weak) id <ISGCycleScrollViewDataSource> dataSource;

#pragma mark - —————————————————————DataSource—————————————————————
/// 网络图片数组
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/// 本地图片数组
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;

#pragma mark - —————————————————————Control Api—————————————————————
/// 自动滚动间隔时间,默认5s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/// 是否无限循环,默认Yes
@property (nonatomic, assign) BOOL infiniteLoop;

/// 是否自动滚动,默认Yes
@property (nonatomic, assign) BOOL autoScroll;

/// 滚动方向，默认为水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

#pragma mark - —————————————————————Style Api—————————————————————

/// 图片缩放模式，默认UIViewContentModeScaleToFill
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;

/// 占位图，用于网络未加载到图片时
@property (nonatomic, strong) UIImage *placeholderImage;

/// 是否显示分页控件,默认YES
@property (nonatomic, assign) BOOL showPageControl;

/// 是否在只有一张图时隐藏pagecontrol，默认为YES
@property(nonatomic) BOOL hidesForSinglePage;

/// pagecontrol 样式，默认为系统经典样式
@property (nonatomic, assign) ISGPageControlStyle pageControlStyle;

/// 分页控件位置,默认PageControlAlignmentCenter
@property (nonatomic, assign) ISGPageControlAlignment pageControlAliment;

/// 分页控件小圆标大小，默认CGSizeMake(10, 10)
@property (nonatomic, assign) CGSize pageControlDotSize;

/// 当前分页控件小圆标颜色
@property (nonatomic, strong) UIColor *currentPageDotColor;

/// 其他分页控件小圆标颜色
@property (nonatomic, strong) UIColor *pageDotColor;

/// 当前分页控件小圆标图片
@property (nonatomic, strong) UIImage *currentPageDotImage;

/// 其他分页控件小圆标图片
@property (nonatomic, strong) UIImage *pageDotImage;

/// 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/// 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量
@property (nonatomic, assign) CGFloat pageControlRightOffset;

#pragma mark - —————————————————————Block—————————————————————
/// 点击事件
@property (nonatomic, copy) void (^didSelectAtInex)(NSInteger index);

#pragma mark - —————————————————————Public Method—————————————————————
/// 可以调用此方法手动控制滚动到哪一个index
/// @param index index
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/// 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法
- (void)adjustWhenControllerViewWillAppear;

/// 刷新数据，建议自定义Cell时使用
- (void)reloadData;
@end
