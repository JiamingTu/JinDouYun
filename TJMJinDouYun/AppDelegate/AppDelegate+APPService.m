//
//  AppDelegate+APPService.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "AppDelegate+APPService.h"

@implementation AppDelegate (APPService)
#pragma  mark - 确认登录状态
//确认登录状态（是否存在token）
- (void)checkLoggingStatusWithToken {
    if ([TJMSandBoxManager getTokenModel]) {
        //token 存在 进入首页
        NSLog(@"token存在 确认登录");
    }else {
        //token 进入未登录页面 UIStoryboard
        NSLog(@"token 不存在");
    }
}

#pragma  mark - 更改根视图 动画
- (void)restoreRootViewController:(UIViewController *)rootViewController
{
    typedef void (^Animation)(void);
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:self.window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];    
}
#pragma  mark - 相册权限等
//获取相册权限
+ (void)albumAuthorization:(authBlock)auth {
    //判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            //NSLog(@"不确定的");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                    NSLog(@"限制或者拒绝的");
                    //请在设置中允许“XXX”访问你的照片
                }else {
                    //NSLog(@"允许的");
                    NSLog(@"%@",[NSThread currentThread]);
                    //这里是分线程，需要返回主线程刷新UI
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        auth(YES);
                    }];
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized: {
            //NSLog(@"允许的");
            auth(YES);
        } break;
        case PHAuthorizationStatusDenied: {
            //NSLog(@"禁止的");
            auth(NO);
        } break;
        case PHAuthorizationStatusRestricted: {
            //NSLog(@"限制的");
            auth(NO);
        } break;
        default:
            break;
    }
}
//获得所有相册内容（相机胶卷+相册）
+ (void)getAlbumDataSourceWithOriginal:(BOOL)original Info:(photoInfo)pInfo {
    //创建资源库对象
    /*
     ALAssetsLibrary:代表的是整个设备中的资源库，（照片，视频），通过这个库可以获得
     ALAssetsGrounp:映射的是照片库中的一个相册，通过这个类可以获取某个相册的资源，同时也可以对某个相册添加资源
     ALAsset:映射的是库中的一个照片或者一个视频，通过该类可以获取某个照片或视频的详细信息，或者保存照片或视频
     */
    //方法二
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册
    for (PHAssetCollection *assetCollection in assetCollections) {
        NSLog(@"collectionName:%@",assetCollection);
        [self enumerateAssetsInAssetCollection:assetCollection original:original localIdentifier:nil info:^(UIImage *image, PHAsset *asset) {
            pInfo(image,asset);
        }];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:original localIdentifier:nil info:^(UIImage *image, PHAsset *asset) {
        pInfo(image,asset);
    }];
}

+ (PHAssetCollection *)getalbumDatasource {
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    return cameraRoll;
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 *  @param locaIdentifier 只要一张选取的图片
 */
+ (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original localIdentifier:(NSString *)locaIdentifier info:(photoInfo)pInfo
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        if (locaIdentifier) {
            if ([locaIdentifier isEqualToString:asset.localIdentifier]) {
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    pInfo(result,asset);
                }];
            }
        }else {
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                pInfo(result,asset);
            }];
        }
        
    }
}




@end
