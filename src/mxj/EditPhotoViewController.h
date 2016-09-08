//
//  EditPhotoViewController.h
//  mxj
//  P7-2-2编辑照片
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface EditPhotoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *picImageView; //大图ImageView
@property (assign, nonatomic) BOOL intoFlag; //入口标记 YES:相机胶卷 NO:街拍发布
@property (strong, nonatomic) NSMutableArray *editImageArray;       //待编辑图片数组

@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;  //行一
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;  //主TableView

@property (weak, nonatomic) IBOutlet UIImageView *firstSmallBackImageView;    //小图一背景
@property (weak, nonatomic) IBOutlet UIButton *firstSmallBtn;                 //小图一按钮
@property (weak, nonatomic) IBOutlet UIImageView *secondSmallBackImageView;   //小图二背景
@property (weak, nonatomic) IBOutlet UIButton *secondeSmallBtn;               //小图二按钮
@property (weak, nonatomic) IBOutlet UIImageView *thirdSmallBackImageView;    //小图三背景
@property (weak, nonatomic) IBOutlet UIButton *thirdSmallBtn;                 //小图三按钮
@property (weak, nonatomic) IBOutlet UIImageView *fourthSmallBackImageView;   //小图四背景
@property (weak, nonatomic) IBOutlet UIButton *fourthSmallBtn;                //小图四按钮

@property (weak, nonatomic) IBOutlet UIButton *backButton;                //后退按钮
@property (weak, nonatomic) IBOutlet UIImageView *headerView;             //导航栏

@property (strong, nonatomic) UIButton *addButton;                //添加按钮按钮

@property (strong, nonatomic) NSMutableArray *photo1LabelCoordinateArray;     //图片1标签坐标数组
@property (strong, nonatomic) NSMutableArray *photo2LabelCoordinateArray;     //图片2标签坐标数组
@property (strong, nonatomic) NSMutableArray *photo3LabelCoordinateArray;     //图片3标签坐标数组
@property (strong, nonatomic) NSMutableArray *photo4LabelCoordinateArray;     //图片4标签坐标数组

@property (copy, nonatomic) NSString *addLabelName;   //tag添加成功的标记，无值：添加失败 有值：添加成功
@property (copy, nonatomic) NSString *addLabelId;     //tagId

@property (assign, nonatomic) int selectImageFlag;   //当前选中的小图
@property (assign, nonatomic) int addLabelFlag;     //是否增加了标签 1:增加标签 0:未增加标签

@property (weak, nonatomic) UITapGestureRecognizer *tmpGesture;     //保存点击的是哪个
@property (strong, nonatomic) UIView *biaoqianBackView;     //标签选择视图

@property (strong, nonatomic) UIView *biaoqianChooseView;     //保存点击的是哪个

@property (strong, nonatomic) IBOutlet UIView *biaoqianInputView;     //保存点击的是哪个

@property (strong, nonatomic) IBOutlet UILabel *biaoqianInputLabel;

@property (strong, nonatomic) IBOutlet UITextField *biaoqianInputTitleTextField;

@property (strong, nonatomic) IBOutlet UITextField *biaoqianInputLinkTextField;

@property (strong, nonatomic) IBOutlet UIButton *biaoqianInputSureButton;

@property (strong, nonatomic) IBOutlet UIButton *biaoqianInputCancelButton;

@property (nonatomic, strong) UIImage *editImage;

@end
