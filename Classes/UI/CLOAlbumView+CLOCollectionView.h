//
//  CLOAlbumView+CLOCollectionView.h
//  AFNetworking
//
//  Created by Cc on 2019/7/23.
//

#import "CLOAlbumView.h"

NS_ASSUME_NONNULL_BEGIN

@class CLOAlbumViewConfig;

@interface CLOAlbumView (CLOCollectionView)
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

- (void)initCollectionView;

@end

NS_ASSUME_NONNULL_END
