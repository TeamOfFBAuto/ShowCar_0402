//
//  LPhotoTool.m
//  ShowCar
//
//  Created by lichaowei on 15/4/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LPhotoTool.h"

@implementation LPhotoTool

+ (id)LPhotoInstance
{
    static LPhotoTool *photoTool;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        photoTool = [[LPhotoTool alloc]init];
    });
    
    return photoTool;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)showLastImageForImageView:(UIImageView *)imageView
{
    ALAssetsLibrary* library = self.library;
    
    if (library == nil) {
        
        self.library = [[ALAssetsLibrary alloc] init];
        
    }
    
    // Block called for every asset selected
    void (^selectionBlock)(ALAsset*, NSUInteger, BOOL*) = ^(ALAsset* asset,
                                                            NSUInteger index,
                                                            BOOL* innerStop) {
        // The end of the enumeration is signaled by asset == nil.
        if (asset == nil) {
            return;
        }
        
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        
        // Retrieve the image orientation from the ALAsset
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        CGFloat scale  = 0.5;
        UIImage* image = [UIImage imageWithCGImage:[representation fullResolutionImage]
                                             scale:scale orientation:orientation];
        
        // do something with the image
        
        __weak typeof(imageView)weakImageView = imageView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) {
                
                weakImageView.image=image;
                
                NSLog(@"图片有效---->%@",image);
                
            }else
            {
                NSLog(@"图片为空---->%@",image);
                
            }
            
        });

    };
    
    // Block called when enumerating asset groups
    void (^enumerationBlock)(ALAssetsGroup*, BOOL*) = ^(ALAssetsGroup* group, BOOL* stop) {
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Get the photo at the last index
        NSUInteger index              = [group numberOfAssets] - 1;
        NSIndexSet* lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index];
        [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:selectionBlock];
    };
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:enumerationBlock
                         failureBlock:^(NSError* error) {
                             // handle error
                         }];
}



#pragma -----------------------------------------------------

//按照时间排序 NSURL
+ (NSArray *)ss:(NSArray *)array
{
    NSArray *sortedContent = [array sortedArrayUsingComparator:^NSComparisonResult(NSURL *obj1, NSURL *obj2) {
        
        NSDate *file1Date;
        [obj1 getResourceValue:&file1Date forKey:NSURLContentModificationDateKey error:nil];
        
        NSDate *file2Date;
        [obj2 getResourceValue:&file2Date forKey:NSURLContentModificationDateKey error:nil];
        
        return [file2Date compare:file1Date];
        
    }];
    
    return sortedContent;
}

+ (void)getImgsForImageView:(UIImageView *)aImageView{
    
    
    int sum = 0;
    
    __block int weakSum = sum;
    
    
    __block NSMutableArray *urlArr = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    
                    NSURL *url = result.defaultRepresentation.url;
                    
                    [urlArr addObject:url];
                    
//                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    
                    if (index + 1 == weakSum) {
                    
                        NSArray *temp = [LPhotoTool ss:urlArr];
                        
                        NSURL *last = [temp lastObject];
                        
                        [self getImageForUrl:last imageView:aImageView];
                        
                        NSLog(@"diudiu");
                        
                    }
                }
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (group == nil)
            {
                
            }
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }
                
                NSLog(@"--->一共多少张 %d",(int)group.numberOfAssets);
                
                weakSum = (int)group.numberOfAssets;
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
    }); 
    
}

/**
 *  根据URL获取照片
 */
+ (void)getImageForUrl:(NSURL *)url imageView:(UIImageView *)aImageView
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    __weak typeof(aImageView)weakImageV = aImageView;
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            
            if (image) {
                weakImageV.image=image;
                
                NSLog(@"图片有效---->%@",image);
                
            }else
            {
                NSLog(@"图片为空---->%@",image);
                
            }
            
        });
        
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
}


/**
 *  根据图片的url反取图片
 *
 *  @param urlStr     图片url地址
 *  @param aImageView 需要显示图片得imageView
 */
+ (void)getImageForUrlString:(NSString *)urlStr imageView:(UIImageView *)aImageView
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    __weak typeof(aImageView)weakImageV = aImageView;
    
    NSURL *temp = [NSURL URLWithString:urlStr];
    
    [assetLibrary assetForURL:temp resultBlock:^(ALAsset *asset)  {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            
            if (image) {
                weakImageV.image=image;
                
                NSLog(@"图片有效---->%@",image);
                
            }else
            {
                NSLog(@"图片为空---->%@",image);

            }
            
            
        });
        
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
}


/**
 *  获取所有照片、视频等
 */
- (void)fillAssetGroups {
    
    NSMutableArray *_assetGroups = [NSMutableArray array];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];//生成整个photolibrary句柄的实例
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
                NSString* assetType = [result valueForProperty:ALAssetPropertyType];
                if ([assetType isEqualToString:ALAssetTypePhoto]) {
                    NSLog(@"Photo");
                    [_assetGroups addObject:result];
                    
                }else if([assetType isEqualToString:ALAssetTypeVideo]){
                    NSLog(@"Video");
                }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                    NSLog(@"Unknow AssetType");
                }
                
                NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
                NSUInteger assetCounter = 0;
                for (NSString *assetURLKey in assetUrls) {
                    NSLog(@"Asset URL %lu = %@",(unsigned long)assetCounter,[assetUrls objectForKey:assetURLKey]);
                }
                
            }];
        } else {
            //stop
            dispatch_async(dispatch_get_main_queue(), ^(void) {

                
            });
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
}


@end
