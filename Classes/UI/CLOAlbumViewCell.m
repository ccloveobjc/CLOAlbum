//
//  CLOAlbumViewCell.m
//  CLOAlbum
//
//  Created by Cc on 2019/7/24.
//

#import "CLOAlbumViewCell.h"
#import "CLOAlbumViewConfig.h"
#import <CLOAlbum/CLOAlbumCore.h>

@interface CLOAlbumViewCell ()

@property (nonatomic) CLOAlbumViewConfig *mConfig;
@property (nonatomic) PHAsset *mAsset;
@property (nonatomic) PHImageRequestID mImageRequestID;
@property (nonatomic) CALayer *mImageLayer; 

@end
@implementation CLOAlbumViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (_mAsset && _mConfig) {
        
        [_mConfig.mAlbumHelper fCancelImageRequest:_mImageRequestID];
        _mImageRequestID = 0;
        _mAsset = nil;
    }
    
    self.mImageLayer.contents = nil;
}

- (void)setupConfig:(CLOAlbumViewConfig *)config
{
    _mConfig = config;
    
    self.mImageLayer.contents = nil;
}

- (void)setupPHAsset:(PHAsset *)asset
{
    NSAssert(_mConfig, @"没有设置config   - setupConfig:");
    // 如果asset 一致， 不用再查找
    if (_mAsset && _mAsset.localIdentifier == asset.localIdentifier) {
        
        return;
    }
    
    _mAsset = asset;
    
    CGSize size = [self.mConfig.mItemSize ToCGSize];
    size.width *= 2;
    size.height *= 2;
    [_mConfig.mAlbumHelper fGetSmallItemImage:asset withTargetSize:size withResultHandler:^(UIImage *result, NSDictionary *info) {
        
        self.mImageLayer.contents =  (__bridge id)(result.CGImage);
    }];
}

-(CALayer *)mImageLayer
{
    if (_mImageLayer == nil) {
        // 创建layer对象
        _mImageLayer = [CALayer layer];
        // 设置图层的frame
        _mImageLayer.frame = self.bounds;
        // 设置背景颜色
        _mImageLayer.backgroundColor = [UIColor greenColor].CGColor;
        
        _mImageLayer.masksToBounds = YES;
        
        _mImageLayer.contentsGravity = kCAGravityResizeAspectFill;
        
        [self.layer addSublayer:_mImageLayer];
    }
    return _mImageLayer;
}

@end
