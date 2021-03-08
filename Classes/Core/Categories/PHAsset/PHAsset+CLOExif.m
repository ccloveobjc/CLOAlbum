//
//  PHAsset+CLOExif.m
//  CLOAlbum
//
//  Created by Cc on 2020/12/9.
//

#import "PHAsset+CLOExif.h"

@implementation PHAsset (CLOExif)

- (void)CLOGetUIImage:(BOOL)synchronous
             longSize:(NSInteger)analysePhotoSize
             allowNet:(BOOL)allowNet
      progressHandler:(PHAssetImageProgressHandler)progressHandler
             callback:(void(^)(UIImage *image, NSDictionary *info))completionBlock
{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = allowNet;
    options.synchronous = synchronous;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.progressHandler = progressHandler;
    PHImageManager *manager = [PHImageManager defaultManager];
    
    [manager requestImageForAsset:self targetSize:CGSizeMake(analysePhotoSize, analysePhotoSize) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completionBlock) {
            completionBlock(result, info);
        }
    }];
}
- (void)CLOGetMetadata:(BOOL)synchronous
              allowNet:(BOOL)allowNet
       progressHandler:(PHAssetImageProgressHandler)progressHandler
              callback:(void(^)(NSData *imageData, NSDictionary *metadata, NSDictionary *info))completionBlock
{
    @autoreleasepool {
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.networkAccessAllowed = allowNet;
        options.synchronous = synchronous;
        options.version = PHImageRequestOptionsVersionCurrent;
        options.progressHandler = progressHandler;
        PHImageManager *manager = [PHImageManager defaultManager];
        if (@available(iOS 13, *))
        {
            [manager requestImageDataAndOrientationForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                
                if (imageData) {
                    
                    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, nil);
                    if (imageSourceRef) {
                        
                        CFDictionaryRef cfMetadata = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil);
                        if (cfMetadata)
                        {
                            NSDictionary *metaDataDic = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)(cfMetadata)];
                            completionBlock(imageData, metaDataDic, info);
                            CFRelease(cfMetadata);
                        }
                        else
                        {
                            completionBlock(imageData, nil, info);
                        }
                        CFRelease(imageSourceRef);
                    }
                } else {
                    
                    completionBlock(imageData, nil, info);
                }
            }];
        }
        else
        {
            [manager requestImageDataForAsset:self options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                
                if (imageData) {
                    
                    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, nil);
                    if (imageSourceRef) {
                        
                        CFDictionaryRef cfMetadata = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil);
                        if (cfMetadata)
                        {
                            NSDictionary *metaDataDic = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)(cfMetadata)];
                            completionBlock(imageData, metaDataDic, info);
                            CFRelease(cfMetadata);
                        }
                        else
                        {
                            completionBlock(imageData, nil, info);
                        }
                        CFRelease(imageSourceRef);
                    }
                } else {
                    
                    completionBlock(imageData, nil, info);
                }
            }];
        }
    }
}

+ (CGSize)CLOGetClipSize:(PHAsset *)asset frameSize:(CGSize)frameSize
{
    // 这里要计算
    double w = (double)asset.pixelWidth;
    double h = (double)asset.pixelHeight;
    
    double fw = frameSize.width;
    double fh = frameSize.height;
    
    //以w为基准
    double neww = MIN(fw, w);
    double newh = h / w * neww;
    if (newh > fh)
    {
        // 以h为基准
        newh = fh;
        neww = w / h * newh;
    }
    
    int nw = (int) neww;
    int nh = (int) newh;
    
    return CGSizeMake(nw, nh);
}

@end
