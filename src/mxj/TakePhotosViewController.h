//
//  TakePhotosViewController.h
//  mxj
//  P7-2拍照
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface TakePhotosViewController : BaseViewController

@property (nonatomic, strong) UIImagePickerController *imagePickerCtrl;  //照相机
@property (weak, nonatomic) IBOutlet UIButton *backBtn;             //返回按钮
@property (weak, nonatomic) IBOutlet UIButton *reCaptureBtn;        //重拍按钮
@property (weak, nonatomic) IBOutlet UIButton *userPhotoBtn;        //使用照片按钮
@property (weak, nonatomic) IBOutlet UIButton *capturePhotoBtn;     //拍照按钮

@end
