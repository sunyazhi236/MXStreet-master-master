//
//  RegisterCreatePersonInfViewController.h
//  mxj
//  P4-1注册-创建个人资料ViewController头文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

@interface RegisterCreatePersonInfViewController : BaseViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField; //姓名TextField
@property (weak, nonatomic) IBOutlet UIButton *manBtn;       //男性按钮
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;     //女性按钮
@property (weak, nonatomic) IBOutlet UITextField *storeName; //店铺名称
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;     //地区标签
@property (weak, nonatomic) IBOutlet UIImageView *personImageView; //个人头像

@property (strong, nonatomic) IBOutlet UIView *uploadPhotoView; //头像选择视图

@end
