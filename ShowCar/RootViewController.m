//
//  RootViewController.m
//  ShowCar
//
//  Created by lichaowei on 15/3/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "RootViewController.h"
#import "AnliListViewController.h"
#import "SecondViewController.h"
#import "PersonalViewController.h"


@interface RootViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIActionSheetDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareItems];
    
//    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)prepareItems
{
    NSArray *classNames = @[@"AnliListViewController",@"UIViewController",@"PersonalViewController"];
//    NSArray *item_names = @[@"案例",@"+",@"个人"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3;i ++) {
        
        NSString *className = classNames[i];
        UIViewController *vc = [[NSClassFromString(className) alloc]init];
        UINavigationController *unvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [items addObject:unvc];
        
    }
    
    self.viewControllers = [NSArray arrayWithArray:items];
    
//    CGSize tabbarSize = self.tabBar.frame.size;
    
    CGSize allSize = [UIScreen mainScreen].applicationFrame.size;
    
//    CGFloat aWidth = allSize.width / 5;
    
    NSArray *normalImages = @[@"homepage_uncheck",@"homepage_publish_uncheck",@"homepage_personal_uncheck"];
    NSArray *selectedImages = @[@"homepage_check",@"homepage_publish_check",@"homepage_personal_check"];
    
    for (int i = 0; i < 3; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        UIImage *aImage = [UIImage imageNamed:[normalImages objectAtIndex:i]];
        aImage = [aImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = aImage;
        
        UIImage *selectImage = [UIImage imageNamed:[selectedImages objectAtIndex:i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = selectImage;
        
//        if (i != 1) {
//            item.title = [item_names objectAtIndex:i];
//        }
        
        //中间特殊按钮
        
//        if (i == 1) {
            //上 左 下 右
            [item setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
            
//            UIButton *center = [UIButton buttonWithType:UIButtonTypeCustom];
//            center.frame = CGRectMake(0, 0, aWidth, tabbarSize.height);
//            [self.tabBar addSubview:center];
//            center.backgroundColor = [UIColor clearColor];
//            center.center = CGPointMake(DEVICE_WIDTH/2.f, center.center.y);
//            center.tag = 102;
//            [center setImage:[UIImage imageNamed:normalImages[1]] forState:UIControlStateNormal];
//            [center setImage:[UIImage imageNamed:selectedImages[1]] forState:UIControlStateSelected];
//            [center addTarget:self action:@selector(clickToSelectForIndex:) forControlEvents:UIControlEventTouchUpInside];
//        }
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"666666"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"dc4b6c"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
//    self.tabBar.backgroundColor = [UIColor redColor];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"home_tiao"];
}


- (void)clickToSelectForIndex:(UIButton *)sender
{
    //控制中间按钮
    
    if (sender.tag - 100 == 2) {
        NSLog(@"点击加号");
        
        [self showMenu];
        
        return;
    }
    
    self.selectedIndex = sender.tag - 100;
}

- (void)showMenu {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [sheet showInView:self.view];
}

- (void)clickToPublish:(UIButton *)sender
{
//    PublishHuatiController *publish = [[PublishHuatiController alloc]init];
//    publish.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:publish animated:YES];
}

- (void)pushToViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)self.selectedViewController pushViewController:viewController animated:YES];
}


#pragma mark - 事件处理

- (void)dealWithImage:(UIImage *)aImage
{
    NSLog(@"进入发布案例页面");
}

#pragma mark - UITabBarControllerDelegate

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    NSLog(@"--> %d  %@",(int)tabBarController.selectedIndex,viewController);
//    
//    if (tabBarController.selectedIndex == 1) {
//        [self showMenu];
//    }
//    
//}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSLog(@"相册");
        [self clickToAddAlbum:nil];

        
    }else if (buttonIndex == 1){
        
        NSLog(@"相机");
        
        
        [self clickToPhoto:nil];
        
    }
}

#pragma mark - 图片选择

/**
 *  添加添加图片
 */

- (void)clickToAddAlbum:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  拍照
 */

- (void)clickToPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];

    BOOL isOk = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (isOk == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"不支持照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [self scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>1024?1024:originImage.size.width,originImage.size.width>1024?originImage.size.height*1024/originImage.size.width:originImage.size.height)];
        //        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        NSData *data;
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.4);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        // 这里是 ToDo:
        
        [self dealWithImage:image];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma - mark 切图

- (UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
