//
//  CLOAlbumHelper+Exif.h
//  AFNetworking
//
//  Created by TT on 2019/7/21.
//

#import "CLOAlbumHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLOAlbumHelper (Exif)

- (void)fGetAssetExif:(PHAsset *)asset withExifHander:(void(^)(NSData *imageData, NSDictionary *exif, NSDictionary *gps))imageInfoHander;

@end

NS_ASSUME_NONNULL_END
