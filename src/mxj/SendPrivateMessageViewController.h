//
//  SendPrivateMessageViewController.h
//  mxj
//  P8-3-1发送私信头文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SendPrivateMessageViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *sendPrivateMessageTableView; //发送私信TableView
@property (weak, nonatomic) IBOutlet UIView *footInputView; //底部输入框
@property (weak, nonatomic) IBOutlet UITextView *inputTextFiled; //输入区域
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView; //背景图
@property (nonatomic, strong) GetMessage *info; //聊天记录
@property (nonatomic, copy) NSString *userName; //标题名称
@property (nonatomic, copy) NSString *receiveId; //收信者Id
@property (nonatomic, copy) NSMutableDictionary *dict; //接口请求字典

@end
