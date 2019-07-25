//
//  UIImagePickerController+CLOAlbumUI.m
//  CLOCommon
//
//  Created by Cc on 2017/7/7.
//
//

#import "UIImagePickerController+CLOAlbumUI.h"
#import <objc/runtime.h>
#import <MobileCoreServices/UTCoreTypes.h>

@implementation UIImagePickerController (CLOAlbumUI)

- (bCLOSelectBlock)mSelectBlock
{
    return objc_getAssociatedObject(self, "mSelectBlock");
}

- (void)setMSelectBlock:(bCLOSelectBlock)block
{
    objc_setAssociatedObject(self, "mSelectBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (bCLOCancelBlock)mCancelBlock
{
    return objc_getAssociatedObject(self, "mCancelBlock");
}

- (void)setMCancelBlock:(bCLOCancelBlock)block
{
    objc_setAssociatedObject(self, "mCancelBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (UIImagePickerController *)CLOImagePickerSelectOne:(bCLOSelectBlock)block andCancelBlock:(bCLOCancelBlock)cancel
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = [UIColor orangeColor];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = sourcheType;
    picker.delegate = picker;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    picker.mSelectBlock = block;
    picker.mCancelBlock = cancel;
    
    return picker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __block UIImage *img = info[UIImagePickerControllerOriginalImage];
    if (img) {
        
        bCLOSelectBlock b = [self mSelectBlock];
        if (b) {
            
            BOOL bRet = b(img);
            if (bRet) {
                
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    bCLOCancelBlock b = [self mCancelBlock];
    if (b) {
        
        b();
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
