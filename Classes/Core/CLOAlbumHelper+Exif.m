//
//  CLOAlbumHelper+Exif.m
//  AFNetworking
//
//  Created by TT on 2019/7/21.
//

#import "CLOAlbumHelper+Exif.h"

@implementation CLOAlbumHelper (Exif)

- (void)fGetAssetExif:(PHAsset *)asset withExifHander:(void(^)(NSData *imageData, NSDictionary *exif, NSDictionary *gps))imageInfoHander
{
    if (imageInfoHander) {
    
        [self CLOGotOriginImageData:asset withResultHandler:^(NSData *imageData, NSDictionary *exif) {
            
            if (imageData == nil)
            {
                imageInfoHander(imageData, nil, nil);
                return;
            }
            CGImageSourceRef imgSource = CGImageSourceCreateWithData((CFDataRef)imageData, nil);
            CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(imgSource, 0, NULL);
            
            NSDictionary *exifInfo = (__bridge NSDictionary *)CFDictionaryGetValue(imageInfo, kCGImagePropertyExifDictionary);
            
            NSDictionary *gpsInfo = (__bridge NSDictionary *)CFDictionaryGetValue(imageInfo, kCGImagePropertyGPSDictionary);
            
            imageInfoHander(imageData, exifInfo, gpsInfo);
            
            CFRelease(imageInfo);
            CFRelease(imgSource);
        }];
    }
}

@end
