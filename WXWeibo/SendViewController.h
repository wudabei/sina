//
//  SendViewController.h
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WXFaceScrollerView.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    NSMutableArray *_buttons;
    // 全屏显示的图片
    UIImageView    *_imageView;
    WXFaceScrollerView *_faceView;
    
}
//send data
// 经度
@property (nonatomic,copy)NSString *longitude;
// 纬度
@property (nonatomic,copy)NSString *latitude;
// 要发送的图片
@property (nonatomic,copy)UIImage *sendImage;
// 图片缩略图视图
@property (nonatomic,retain)UIButton *sendImageButton;
//地理位置视图
@property (retain, nonatomic) IBOutlet UIView *placeView;
//地理位置标签
@property (retain, nonatomic) IBOutlet UILabel *placeLabel;
//地理位置背景图片
@property (retain, nonatomic) IBOutlet UIImageView *placeBackgroundView;
// 编辑输入框
@property (retain, nonatomic) IBOutlet UITextView *textView;
// 工具栏 
@property (retain, nonatomic) IBOutlet UIView *editorBar;
@end
