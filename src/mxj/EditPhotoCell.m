//
//  EditPhotoCell.m
//  mxj
//  P7-2-2编辑照片
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "EditPhotoCell.h"

@implementation EditPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [_linkTextView setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [_linkTextViewDelegate textViewShouldBeginEditing:textView];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [_linkTextViewDelegate textViewShouldEndEditing:textView];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    //调整TextView高度
    /*
    float height = [CustomUtil heightForString:textView.text fontSize:13.0f andWidth:textView.frame.size.width];
    CGRect frame = textView.frame;
    frame.size.height = height;
    textView.frame = frame;
    
    //调整cell的高度
    frame = self.frame;
    frame.size.height = height + 4;
    self.frame = frame;
    
    //调整底部分割线
    CGRect rect = self.lineImageView.frame;
    rect.origin.y = self.frame.size.height - 1;
    self.lineImageView.frame = rect;
     */
    
    [_linkTextViewDelegate textViewDidChange:textView];
    
    return;
}

@end
