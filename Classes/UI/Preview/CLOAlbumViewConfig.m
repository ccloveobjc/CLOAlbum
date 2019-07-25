//
//  CLOAlbumViewConfig.m
//  CLOAlbum
//
//  Created by Cc on 2019/7/23.
//

#import "CLOAlbumViewConfig.h"

@implementation CLOAlbumViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _mScrollDirection = UICollectionViewScrollDirectionVertical;
        _mMinimumLineCount = 3;
        _mMinimumLineSpacingPercent = 0.01;
        _mParamsCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setMItemSize:(CLOSize *)mItemSize
{
    self.mParamsCache[@"CLOAlbumView+CLOCollectionView.mItemSize"] = mItemSize;
}
- (CLOSize *)mItemSize
{
    return self.mParamsCache[@"CLOAlbumView+CLOCollectionView.mItemSize"];
}

- (void)setMMinimumLineSpacing:(NSNumber *)mMinimumLineSpacing
{
    self.mParamsCache[@"CLOAlbumView+CLOCollectionView.mMinimumLineSpacing"] = mMinimumLineSpacing;
}
- (NSNumber *)mMinimumLineSpacing
{
    return self.mParamsCache[@"CLOAlbumView+CLOCollectionView.mMinimumLineSpacing"];
}
@end
