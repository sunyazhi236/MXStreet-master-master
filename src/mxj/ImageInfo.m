//
//  ImageInfo.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "ImageInfo.h"
@implementation ImageInfo
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([[dictionary allKeys] containsObject:@"publishPlace"]) { //街拍或首页
            _publishPlace = [dictionary objectForKey:@"publishPlace"];
            _streetsnapId = [dictionary objectForKey:@"streetsnapId"];
            _streetsnapContent = [dictionary objectForKey:@"streetsnapContent"];
            _publishTime = [dictionary objectForKey:@"publishTime"];
            _userName = [dictionary objectForKey:@"userName"];
            _image = [dictionary objectForKey:@"image"];
            _photo1 = [dictionary objectForKey:@"photo1"];
             _praiseNum = [dictionary objectForKey:@"praiseNum"];
            _commentNum = [dictionary objectForKey:@"commentNum"];
            self.thumbURL = [CustomUtil getPhotoPath:_photo1];
            //CGSize waterImageView = [CustomUtil getPhotoSizeWithURLStr:_photo1];
            
            
            //根据文字设定视图的尺寸
            /*
            CGRect fontRect = [CustomUtil heightForString:_streetsnapContent width:180];
            if (fontRect.size.height < 20) {
                _height = 218;
            } else {
                _height = 241;
            }
             */
            //self.height = waterImageView.height;
            self.width = (SCREEN_WIDTH - (5 * 4))/2;
            //self.height = self.width/waterImageView.width * waterImageView.height;
            self.height = self.width;
        } else {  //我的收藏
            _streetsnapId1 = [dictionary objectForKey:@"streetsnapId"];
            _streetsnapContent1 = [dictionary objectForKey:@"streetsnapContent"];
            _publishTime1 = [dictionary objectForKey:@"publishTime"];
            _photo12 = [dictionary objectForKey:@"photo1"];
            //self.height = [CustomUtil heightForString:_streetsnapContent1].size.height;
            //self.width = [CustomUtil heightForString:_streetsnapContent1].size.width;
            //CGRect fontRect = [CustomUtil heightForString:_streetsnapContent1 width:180];
            _width = (SCREEN_WIDTH - (5*4))/2;
            _height = _width;
            self.thumbURL = [CustomUtil getPhotoPath:_photo12];
        }
        if ([CustomUtil CheckParam:_thumbURL]) {
            self.thumbURL = [dictionary objectForKey:@"thumbURL"];
        }
        if (0 == _width) {
            self.width = [[dictionary objectForKey:@"width"] floatValue];
        }
        if (0 == _height) {
            self.height = [[dictionary objectForKey:@"height"] floatValue];
        }
    }
    return self;
}

- (id)initLabelImageWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        _publishPlace = [dictionary objectForKey:@"publishPlace"];
        _streetsnapId = [dictionary objectForKey:@"streetsnapId"];
        _streetsnapContent = [dictionary objectForKey:@"streetsnapContent"];
        _publishTime = [dictionary objectForKey:@"publishTime"];
        _userName = [dictionary objectForKey:@"userName"];
        _image = [dictionary objectForKey:@"image"];
        _photo1 = [dictionary objectForKey:@"photo1"];
        _praiseNum = [dictionary objectForKey:@"praiseNum"];
        _commentNum = [dictionary objectForKey:@"commentNum"];
        self.thumbURL = [CustomUtil getPhotoPath:_photo1];
        
        self.width = (SCREEN_WIDTH - (5 * 4))/2;
        //self.height = self.width/waterImageView.width * waterImageView.height;
        self.height = self.width;

        if ([CustomUtil CheckParam:_thumbURL]) {
            self.thumbURL = [dictionary objectForKey:@"thumbURL"];
        }
        if (0 == _width) {
            self.width = [[dictionary objectForKey:@"width"] floatValue];
        }
        if (0 == _height) {
            self.height = [[dictionary objectForKey:@"height"] floatValue];
        }
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"thumbURL:%@ width:%f height:%f",self.thumbURL,self.width,self.height];
}

//获取文字高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return deSize.height;
}

@end
