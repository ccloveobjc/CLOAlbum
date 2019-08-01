//
//  CLOAlbumMgr.h
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 *  当mAllPhotos 有改变时通知
 */
extern NSString *const kNotification_AllPhotosChanged;
//extern NSString *const kNotification_AllSectionsChanged;

@interface CLOAlbumHelper : NSObject

    /**
     相册名字
     */
    @property (nonatomic,strong) NSString *mCLOAlbumName;

    /**
     所有照片
     */
    @property (nonatomic,strong,readonly) PHFetchResult<PHAsset *> *mAllPhotos;


    /**
     获取当前相册，如果没有就创建一个
     */
    @property (nonatomic,strong,readonly) PHAssetCollection *mCurrentAssetCollection;


//    + (instancetype)sInstance;


/**
 查询一张照片

 @param asset 相册对象
 @param targetSize 查询大小
 @param resultHandler block
 @return 查询唯一标示符
 */
- (PHImageRequestID)CLOGotSmallItemImage:(PHAsset *)asset withTargetSize:(CGSize)targetSize
                       withResultHandler:(void (^)(UIImage * result, NSDictionary * info))resultHandler;

/**
 查询一张照片
 
 @param asset           相册对象
 @param targetSize      查询大小
 @param resultHandler   block
 @param opt             参数
 @return 查询唯一标示符
 */
- (PHImageRequestID)CLOGotSmallItemImage:(PHAsset *)asset withTargetSize:(CGSize)targetSize withOptions:(nullable PHImageRequestOptions *)opt
                       withResultHandler:(void (^)(UIImage * result, NSDictionary * info))resultHandler;


/**
 取消查询

 @param requestID 查询唯一标示符
 */
- (void)CLOCancelImageRequest:(PHImageRequestID)requestID;


/**
 删除一张照片

 @param asset 相册对象
 @param completionHandler block
 */
- (void)CLODeleteImage:(PHAsset *)asset withCompletionHandler:(void(^)(BOOL success, NSError * error))completionHandler;


/**
 获取原始图片

 @param asset 相册对象
 @param progress block
 @param completionHandler block
 @return 查询唯一标示符
 */
- (PHImageRequestID)CLOGotOriginImage:(PHAsset *)asset withProgressHandler:(PHAssetImageProgressHandler)progress  withCompleteHandler:(void(^)(UIImage *img, NSDictionary *info))completionHandler;


/**
 获取原始图片二进制文件
 
 @param asset 相册对象
 @param resultHandler block
 @return 查询唯一标示符
 */
- (PHImageRequestID)CLOGotOriginImageData:(PHAsset *)asset withResultHandler:(void(^)(NSData *imageData, NSDictionary * info))resultHandler;


/**
 获取所有相册信息

 @return 相册
 */
- (PHFetchResult<PHAssetCollection *> *)CLOGotAllCollections;


/**
 获取用户相册信息

 @return 相册
 */
- (NSArray<PHAssetCollection *> *)CLOGotSystemsAndUserCollections;


/**
 获取用户Camera Roll 相册
 */
- (PHAssetCollection *)CLOGotCameraRollCollection;


/**
 获取当前相册第一张图片
 @param collection 相册
 @param limit       最大个数，如果=0表示全部查出
 @return 图片
 */
- (PHFetchResult<PHAsset *> *)CLOGotPHAssetsFromCollection:(PHAssetCollection *)collection fetchLimit:(NSUInteger)limit;

/**
 获取当前相册第一张图片
 @param identifiers     相册
 @param opt             参数
 @return                获取到的PHAsset对象
 */
- (PHFetchResult<PHAsset *> *)CLOFetchAssetsWithLocalIdentifiers:(NSArray<NSString *> *)identifiers options:(nullable PHFetchOptions *)opt;

/**
 获取权限

 @param block status == authorized 表示可以访问相册
 */
- (void)CLOGetAuthorizationStatus:(void(^)(PHAuthorizationStatus status))block;

@end
