//
//  TJMPhotoManager.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPhotoManager.h"

@implementation TJMPhotoManager

+ (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle

{
    // 获取所有的相册
    PHFetchResult *result = [PHAssetCollection           fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册数组,是否已创建该相册
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
}
#pragma mark - 保存图片的方法
+ (void)savePhoto:(UIImage *)image {
    //修改系统相册用PHPhotoLibrary单粒,调用performChanges,否则苹果会报错,并提醒你使用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 调用判断是否已有该名称相册
        PHAssetCollection *assetCollection = [self fetchAssetColletion:
                                              @"QiaoQiaoSong"];
        //创建一个操作图库的对象
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest;
        if (assetCollection) {
            // 已有相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {
            // 1.创建自定义相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"QiaoQiaoSong"];
        }
        // 2.保存你需要保存的图片到系统相册
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 3.把创建好图片添加到自己相册
        //这里使用了占位图片,为什么使用占位图片呢
        //这个block是异步执行的,使用占位图片先为图片分配一个内存,等到有图片的时候,再对内存进行赋值
        PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
        [assetCollectionChangeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //弹出一个界面提醒用户是否保存成功
        if (error) {
            //[SVProgressHUD showErrorWithStatus:@"保存失败"];
        } else {
            // [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];
    
}

@end
