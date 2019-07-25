//
//  UIImagePickerController+CLOAlbumUI.h
//  CLOCommon
//
//  Created by Cc on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

typedef BOOL (^bCLOSelectBlock)(UIImage *img);
typedef void (^bCLOCancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIImagePickerController (CLOAlbumUI)
<
    UINavigationControllerDelegate
    , UIImagePickerControllerDelegate
>

    @property (nonatomic,copy) bCLOSelectBlock mSelectBlock;

    @property (nonatomic,copy) bCLOCancelBlock mCancelBlock;

+ (UIImagePickerController *)CLOImagePickerSelectOne:(bCLOSelectBlock)block andCancelBlock:(bCLOCancelBlock)cancel;

@end

NS_ASSUME_NONNULL_END
