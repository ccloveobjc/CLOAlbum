//
//  CLOAlbumMgr.m
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import "CLOAlbumMgr.h"

NSString *const kNotification_AllPhotosChanged = @"kNotification_AllPhotosChanged";
//NSString *const kNotification_AllSectionsChanged = @"kNotification_AllSectionsChanged";

@interface CLOAlbumMgr()
<
    PHPhotoLibraryChangeObserver
>
    /// 所有照片
    @property (nonatomic,strong) PHFetchResult<PHAsset *> *mAllPhotos;
    /// 用于查询PHAsset
    @property (nonatomic,strong) PHCachingImageManager *mPHCachingImageMgr;
    @property (nonatomic,strong) PHImageRequestOptions *mSmallOptions;
    /// 获取当前相册，如果没有就创建一个
    @property (nonatomic,strong) PHAssetCollection *mCurrentAssetCollection;

@end

@implementation CLOAlbumMgr

+ (instancetype)sInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _mCLOAlbumName = nil;
        PHFetchOptions *opt = [[PHFetchOptions alloc] init];
        opt.sortDescriptors = @[
                                [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]
                                ];
        self.mAllPhotos =  [PHAsset fetchAssetsWithOptions:opt];
        
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

/**
 *  相册照片
 */
- (void)setMAllPhotos:(PHFetchResult<PHAsset *> *)mAllPhotos
{
    _mAllPhotos = mAllPhotos;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AllPhotosChanged object:nil];
    });
}

/**
 *  用于查询PHAsset
 */
- (PHCachingImageManager *)mPHCachingImageMgr
{
    if (!_mPHCachingImageMgr) {
        
        _mPHCachingImageMgr = [PHCachingImageManager defaultManager];
    }
    return _mPHCachingImageMgr;
}

- (PHImageRequestOptions *)mSmallOptions
{
    if (!_mSmallOptions) {
        
        PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
        opt.resizeMode = PHImageRequestOptionsResizeModeFast;
        opt.synchronous = YES;
        opt.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        opt.networkAccessAllowed = NO;
        _mSmallOptions = opt;
    }
    return _mSmallOptions;
}

/** 查询一张图 */
//public func fGetSmallItemImage(for asset: PHAsset, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
//
//    let options = mSmallOptions
//    return _mPHCachingImageMgr.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: {(img: UIImage?, info: [AnyHashable : Any]?) -> Void in
//
//        resultHandler(img, info)
//    })
//}

/** 查询一张图 */
- (PHImageRequestID)fGetSmallItemImage:(PHAsset *)asset withTargetSize:(CGSize)targetSize withResultHandler:(void (^)(UIImage * result, NSDictionary * info))resultHandler
{
    return [self.mPHCachingImageMgr requestImageForAsset:asset
                                              targetSize:targetSize
                                             contentMode:PHImageContentModeAspectFill
                                                 options:self.mSmallOptions
                                           resultHandler:resultHandler];
}

/** 取消查询 */
- (void)fCancelImageRequest:(PHImageRequestID)requestID
{
    [self.mPHCachingImageMgr cancelImageRequest:requestID];
}

/** 删除一张图 */
- (void)fDeleteImage:(PHAsset *)asset withCompletionHandler:(void(^)(BOOL success, NSError * error))completionHandler
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest deleteAssets:asset];
        
    } completionHandler:completionHandler];
}


/** 获取原始图片 */
- (PHImageRequestID)fGetOriginImage:(PHAsset *)asset withProgressHandler:(PHAssetImageProgressHandler)progress  withCompleteHandler:(void(^)(UIImage *img, NSDictionary *info))completionHandler
{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.progressHandler = progress;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    
    return [self.mPHCachingImageMgr requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (completionHandler) {
            
            completionHandler(result, info);
        }
    }];
}

/** 获取所有相册信息 */
- (PHFetchResult<PHAssetCollection *> *)fGetAllCollections
{
    
    PHFetchOptions *opt = [[PHFetchOptions alloc] init];
    return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:opt];
}

- (NSArray<PHAssetCollection *> *)fGetSystemsAndUserCollections
{
    NSMutableArray *arrCollections = [NSMutableArray array];
    
    
    PHFetchResult<PHAssetCollection *> *systemCollections = [self fGetAllCollections];
    for (int i = 0; i < systemCollections.count; ++i) {
        
        PHAssetCollection *collection = systemCollections[i];
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            
            [arrCollections addObject:collection];
        }
    }
    
    for (int i = 0; i < systemCollections.count; ++i) {
        
        PHAssetCollection *collection = systemCollections[i];
        if ([collection.localizedTitle isEqualToString:@"Favorites"]) {
            
            [arrCollections addObject:collection];
        }
    }
    
    PHFetchResult<PHCollection *> *allUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (int i = 0; i < allUserCollections.count; ++i) {
        
        [arrCollections addObject:allUserCollections[i]];
    }
    
    return arrCollections;
}

/** 获取当前相册第一张图片 */
- (PHFetchResult<PHAsset *> *)fGetPHAssetsFromCollection:(PHAssetCollection *)collection
{
    PHFetchOptions *opt = [[PHFetchOptions alloc] init];
    opt.sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    
    opt.predicate = [NSPredicate predicateWithFormat:@"mediaType = %@", @(PHAssetMediaTypeImage)];
    PHFetchResult<PHAsset *> *asset = [PHAsset fetchKeyAssetsInAssetCollection:collection options:opt];
    return asset;
}

/// 获取当前相册，如果没有就创建一个
- (PHAssetCollection *)mCurrentAssetCollection
{
    if (!self.mCLOAlbumName) {
        
        NSAssert(NO, @"");
        return nil;
    }
    
    if (!_mCurrentAssetCollection) {
        
        NSString *AlbumName = self.mCLOAlbumName;
        // 查询相册
        PHFetchOptions *opt = [[PHFetchOptions alloc] init];
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 9.0) {
            
            opt.fetchLimit = 1;
        }
        opt.predicate =  [NSPredicate predicateWithFormat:@"%K = %@", @"localizedTitle", AlbumName];
        PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:opt];
        for (int i = 0; i < result.count; ++i) {
        
            PHAssetCollection *cos = result[i];
            
            if ([cos.localizedTitle isEqualToString:self.mCLOAlbumName]) {
                
                _mCurrentAssetCollection = cos;
                break;
            }
        }
        
        if (_mCurrentAssetCollection == nil) {
            
            // 创建相册
            __block NSString *localIdentifier = nil;
            NSError *err = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                
                localIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.mCLOAlbumName].placeholderForCreatedAssetCollection.localIdentifier;
            } error:&err];
            
            _mCurrentAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifier] options:nil];
        }
    }
    
    return _mCurrentAssetCollection;
}

// MARK: 保存图片到系统相册
/// 保存一张图片到系统相册 和 HC相册
///
/// - Parameters:
///   - img: 图片带 exif
///   - completion: 完成回调，可能保存失败
//private func fSavePhoto(img: UIImage, _ completion:((Bool, Error?) -> Void)?) {
- (void)fSavePhoto:(UIImage *)img withCompletion:(void(^)(BOOL success, NSError *error))completion
{
    // 先保存在系统相册，在保存在HC相册
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        // 保存到系统相册
        assetIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == NO) {
            
            if (completion) { completion(success, error); }
            return;
        }
        
        // 获取当前相册
        PHAssetCollection *col = self.mCurrentAssetCollection;
        if (col == nil) {
            
            NSAssert(NO, @"");
            if (completion != nil) { completion(NO, error); }
            return;
        }
        
        if (assetIdentifier == nil) {
            
            NSAssert(NO, @"");
            if (completion != nil) { completion(NO, error); }
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].firstObject;
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:col];
            
            if (asset != nil) {
                
                [request addAssets:@[asset]];
            }
        } completionHandler:^(BOOL success1, NSError * _Nullable error1) {
            if (success1 == NO) {
                
                NSLog(@"图片保存失败 error  = %@", error1);
            }
            else {
                
                NSLog(@"图片保存成功");
            }
            
            if (completion != nil) { completion(success1, error1); }
        }];
    }];
}

/// 获取当前权限 - Parameter block: status == authorized 表示可以访问相册
- (void)fGetAuthorizationStatus:(void(^)(PHAuthorizationStatus status))block
{
    [PHPhotoLibrary requestAuthorization:block];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.mAllPhotos];
        if (changeDetails) {
            
            self.mAllPhotos = changeDetails.fetchResultAfterChanges;
        }
    });
}
@end
