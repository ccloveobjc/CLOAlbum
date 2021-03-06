//
//  PHAsset+CLOExif.h
//  CLOAlbum
//
//  Created by Cc on 2020/12/9.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (CLOExif)

/**
 获取照片的UIImage
 */
- (void)CLOGetUIImage:(BOOL)synchronous
             longSize:(NSInteger)analysePhotoSize
             allowNet:(BOOL)allowNet
      progressHandler:(PHAssetImageProgressHandler)progressHandler
             callback:(void(^)(UIImage *image, NSDictionary *info))completionBlock;

/**
 获取照片的exif信息
 */
- (void)CLOGetMetadata:(BOOL)synchronous
              allowNet:(BOOL)allowNet
       progressHandler:(nullable PHAssetImageProgressHandler)progressHandler
              callback:(nullable void(^)(NSData *imageData, NSDictionary *metadata, NSDictionary *info))completionBlock;

/**
 获取一个最佳size
 */
+ (CGSize)CLOGetClipSize:(PHAsset *)asset frameSize:(CGSize)frameSize;

@end

NS_ASSUME_NONNULL_END
