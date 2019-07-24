//
//  CLOAlbumViewConfig.h
//  CLOAlbum
//
//  Created by Cc on 2019/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CLOAlbumHelper;
@class CLOSize;

@interface CLOAlbumViewConfig : NSObject

@property (nonatomic) CLOAlbumHelper *mAlbumHelper;
/**
 方向 默认=UICollectionViewScrollDirectionVertical
 */
@property (nonatomic) UICollectionViewScrollDirection mScrollDirection;
/**
 一行最小个数 默认=3
 */
@property (nonatomic) NSInteger mMinimumLineCount;
/**
 间隔 0-1 按百分比来计算 默认=0.01
 */
@property (nonatomic) CGFloat mMinimumLineSpacingPercent;

/**
 保存一些必要参数
 */
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSObject *> *mParamsCache;

/**
 Cell的大小
 */
@property (nonatomic) CLOSize *mItemSize;

/**
 Cell的间距
 */
@property (nonatomic) NSNumber *mMinimumLineSpacing;

@end

NS_ASSUME_NONNULL_END
