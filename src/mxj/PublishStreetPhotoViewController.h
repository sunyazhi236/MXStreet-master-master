//
//  PublishStreetPhotoViewController.h
//  mxj
//  P7-2发布街拍-手机相册
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishStreetPhotoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *publishStreetPhotoTableView;  //表格
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell; //首行Cell

@property (strong, nonatomic) IBOutlet UIButton *nextButton; //首行Cell

@property (assign, nonatomic) BOOL intoFlag; //从哪个画面进入的标记 YES：主页进入 NO:发布进入
@property (strong, nonatomic) NSMutableArray *selectPhotoArray; //选中的图片

@property (strong, nonatomic) NSMutableArray *photo1LabelArray; //图1标签数组
@property (strong, nonatomic) NSMutableArray *photo2LabelArray; //图2标签数组
@property (strong, nonatomic) NSMutableArray *photo3LabelArray; //图3标签数组
@property (strong, nonatomic) NSMutableArray *photo4LabelArray; //图4标签数组

@property (assign, nonatomic) NSInteger photoIndex; //照片下标（1-4）
@property (strong, nonatomic) NSMutableArray *labelArray; //标签数组
@property (strong, nonatomic) NSMutableArray *imageViewArray; //选中的图片右上角ImageView数组

- (IBAction)backBtnClick:(id)sender;

@end
