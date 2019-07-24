//
//  CLOAlbumViewCell.h
//  CLOAlbum
//
//  Created by Cc on 2019/7/24.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class CLOAlbumViewConfig;

@interface CLOAlbumViewCell : UICollectionViewCell

- (void)setupConfig:(CLOAlbumViewConfig *)config;
- (void)setupPHAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
