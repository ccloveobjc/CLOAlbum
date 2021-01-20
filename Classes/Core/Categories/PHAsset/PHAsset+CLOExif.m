//
//  PHAsset+CLOExif.m
//  CLOAlbum
//
//  Created by Cc on 2020/12/9.
//

#import "PHAsset+CLOExif.h"

@implementation PHAsset (CLOExif)

- (void)CLOGetMetadata:(BOOL)synchronous
              allowNet:(BOOL)allowNet
       progressHandler:(PHAssetImageProgressHandler)progressHandler
              callback:(void(^)(NSData *imageData, NSDictionary *metadata))completionBlock
{
    @autoreleasepool {
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.networkAccessAllowed = allowNet;
        options.synchronous = synchronous;
        options.version = PHImageRequestOptionsVersionOriginal;
        options.progressHandler = progressHandler;
        PHImageManager *manager = [[PHImageManager alloc] init];

        [manager requestImageDataForAsset:self options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            
            if (imageData) {
                
                CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, nil);
                if (imageSourceRef) {
                    
                    CFDictionaryRef cfMetadata = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil);
                    if (cfMetadata)
                    {
                        NSDictionary *metaDataDic = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)(cfMetadata)];
                        completionBlock(imageData, metaDataDic);
                        CFRelease(cfMetadata);
                    }
                    else
                    {
                        completionBlock(imageData, nil);
                    }
                    CFRelease(imageSourceRef);
                }
            } else {
                
                completionBlock(imageData, nil);
            }
        }];
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
