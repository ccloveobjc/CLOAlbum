//
//  CLOAlbumView.h
//  CLOAlbum
//
//  Created by Cc on 2019/7/23.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class CLOAlbumViewConfig;

@interface CLOAlbumView : UIView

@property (nonatomic, readonly) PHFetchResult<PHAsset *> *mAssets;

- (instancetype)initWithFrame:(CGRect)frame withConfig:(void (^)(CLOAlbumViewConfig *config))configBlock NS_DESIGNATED_INITIALIZER;

- (void)setPHAssets:(PHFetchResult<PHAsset *> *)assets;

@end

NS_ASSUME_NONNULL_END
