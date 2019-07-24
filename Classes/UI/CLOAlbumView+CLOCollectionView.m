//
//  CLOAlbumView+CLOCollectionView.m
//  AFNetworking
//
//  Created by Cc on 2019/7/23.
//

#import "CLOAlbumView+CLOCollectionView.h"
#import "CLOAlbumViewConfig.h"
#import "CLOAlbumViewCell.h"
#import <CLOCommon/CLOCommonUI.h>

@interface CLOAlbumView ()

//private
@property (nonatomic, readwrite) UICollectionView *mAlbumView;
@property (nonatomic, readwrite) CLOAlbumViewConfig *mAlbumConfig;

@end
@implementation CLOAlbumView (CLOCollectionView)



- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:self.mAlbumConfig.mScrollDirection];
    self.mAlbumView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.mAlbumView.backgroundColor = [UIColor whiteColor];
    [self.mAlbumView registerClass:[CLOAlbumViewCell class] forCellWithReuseIdentifier:@"CLOAlbumViewCell"];
    self.mAlbumView.delegate = self;
    self.mAlbumView.dataSource = self;
    [self addSubview:self.mAlbumView];
    
    // 计算
    self.mAlbumConfig.mMinimumLineSpacing = @(self.width * self.mAlbumConfig.mMinimumLineSpacingPercent);
    NSInteger size_w = (self.width - (self.mAlbumConfig.mMinimumLineCount + 1) * [self.mAlbumConfig.mMinimumLineSpacing floatValue]) / self.mAlbumConfig.mMinimumLineCount;
    self.mAlbumConfig.mItemSize = CLOSizeMake(@(size_w), @(size_w));
}

#pragma make UICollectionViewDelegate

#pragma make UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mAssets.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLOAlbumViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CLOAlbumViewCell" forIndexPath:indexPath];
    //在这里进行各种操作
    cell.contentView.backgroundColor = [UIColor blueColor];
    [cell setupConfig:self.mAlbumConfig];
    [cell setupPHAsset:self.mAssets[indexPath.item]];
    return cell;
}
#pragma make UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mAlbumConfig.mItemSize ToCGSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // top,  left,  bottom,  right
    float cv = [self.mAlbumConfig.mMinimumLineSpacing floatValue];
    return UIEdgeInsetsMake(0, cv, 0, cv);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self.mAlbumConfig.mMinimumLineSpacing floatValue];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

@end
