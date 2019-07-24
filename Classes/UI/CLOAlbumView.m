//
//  CLOAlbumView.m
//  CLOAlbum
//
//  Created by Cc on 2019/7/23.
//

#import "CLOAlbumView.h"
#import "CLOAlbumView+CLOCollectionView.h"
#import "CLOAlbumViewConfig.h"

@interface CLOAlbumView()

//public
@property (nonatomic, readwrite) PHFetchResult<PHAsset *> *mAssets;
//private
@property (nonatomic, readwrite) CLOAlbumViewConfig *mAlbumConfig;
@property (nonatomic, readwrite) UICollectionView *mAlbumView;

@end

@implementation CLOAlbumView

- (instancetype)initWithFrame:(CGRect)frame withConfig:(void (^)(CLOAlbumViewConfig *config))configBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.mAlbumConfig = [CLOAlbumViewConfig new];
        if (configBlock) {
            
            configBlock(self.mAlbumConfig);
        }
        [self initCollectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.mAlbumView.frame = self.bounds;
    [self.mAlbumView setNeedsLayout];
}

- (void)setPHAssets:(PHFetchResult<PHAsset *> *)assets
{
    self.mAssets = assets;
    [self setNeedsLayout];
    [self.mAlbumView reloadData];
}



@end
