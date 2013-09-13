//
//  SendViewController.m
//  WXWeibo
//
//  Created by cannaan on 13-7-26.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "NSString+URLEncoding.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"

#import "DataService.h"
@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        self.isCancelButton = YES;// 需要在 super viewDidload 中执行完成。也就是说super的执行
        self.isBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.title = @"发布微博";
    _buttons = [[NSMutableArray arrayWithCapacity:6]retain];
  
    
    // 创建返回--------抽出到baseViewCV中
//    UIButton *button = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancleAction)];
//    UIBarButtonItem *canle = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = [canle autorelease];

    
    // 发布按钮
    UIButton *sendButton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = [sendItem autorelease];
    
    [self _initViews];
    
}

- (void)_initViews {
    
    // 显示键盘，并且要监听键盘的高度和将要显示的这2个事件。
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"compose_locatebutton_background.png",
                           @"compose_camerabutton_background.png",
                           @"compose_trendbutton_background.png",
                           @"compose_mentionbutton_background.png",
                           @"compose_emoticonbutton_background.png",
                           @"compose_keyboardbutton_background.png",
                           nil];
    
    NSArray *imageHighted = [NSArray arrayWithObjects:@"compose_locatebutton_background_highlighted.png",
                             @"compose_camerabutton_background_highlighted.png",
                             @"compose_trendbutton_background_highlighted.png",
                             @"compose_mentionbutton_background_highlighted.png",
                             @"compose_emoticonbutton_background_highlighted.png",
                             @"compose_keyboardbutton_background_highlighted.png",
                             nil];
    
    
    
    for (int i = 0; i<imageNames.count; i++) {
        NSString *imageName = [imageNames objectAtIndex:i];
        NSString *imageNameHighted = [imageHighted objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:imageNameHighted];
        
        [button setImage:[UIImage imageNamed: imageNameHighted ] forState:UIControlStateSelected];
        button.tag = (10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(20+(64*i), _editorBar.height/2-9, 23, 19);
        [self.editorBar addSubview:button];
        [_buttons addObject:button];
        
        if (i==5) {
            button.hidden = YES;
            button.left -= 64;
        }
    }
    
    // 拉伸图片
    UIImage *image = [self.placeBackgroundView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.placeBackgroundView.image = image;
    self.placeBackgroundView.width = 200;
    
    self.placeLabel.left = 35;
    self.placeLabel.width = 160;
    
    
}

#pragma mark - data
- (void)doSendData {
    [super showStatuseTip:YES title:@"发送中..."];
    NSString *text = self.textView.text;
    
    if (text.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    // 如果有经纬度参数的时候
    if (self.longitude.length >0 ) {
        [params setObject:self.longitude forKey:@"long"];
    }
    if (self.latitude.length > 0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    if (self.sendImage == nil) {
        // 不带图的接口
        [self.sinaweibo requestWithURL:@"statuses/update.json" httpMethod:@"POST" params:params block:^(id result) {
            // 发送提示方式。不适用HUD
            //        [super showHUDComplete:@"发送成功"];
            [super showStatuseTip:NO title:@"发送成功!"];
            
            // 关闭模态视图
            [self cancleAction];
        }];
    }else {// 带图片的.，
        
        //转化图片使得变小。image不能作为参数，他是二进制的，需要image转成data
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 0.3);// 缩小0.3
        
        [params setObject:data forKey:@"pic"];
        
//        [self.sinaweibo requestWithURL:@"statuses/upload.json" httpMethod:@"POST" params:params block:^(id result) {
//            // 发送提示方式。不适用HUD
//            //        [super showHUDComplete:@"发送成功"];
//            [super showStatuseTip:NO title:@"发送成功!"];
//            // 关闭模态视图
//            [self cancleAction];
//        }];
        
        // 使用 ASI请求方式
        [DataService requestWithURL:@"statuses/upload.json" params:params HTTPMethod:@"POST" completeBlock:^(id result) {
            
            [super showStatuseTip:NO title:@"发送成功!"];
            [self cancleAction];
        }];
    }
}
//定位
- (void)location {
    NearbyViewController *near = [[NearbyViewController alloc] init];
    // 因为弹出的效果有导航控制器，所以需要加到导航控制器上面来
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:near];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    [navi release];
    [near release];
    // near 被谁所持有？ near什么时候销毁？
    near.selectBlock = ^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        self.latitude = [result objectForKey:@"lat"];
        self.longitude = [result objectForKey:@"lon"];
        NSString *address = [result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            address = [result objectForKey:@"title"];
        }
    self.placeLabel.text = address;
    self.placeView.hidden = NO;
        
    UIButton *locationBtn = [_buttons objectAtIndex:0];
    locationBtn.selected = YES;
        
    };
    //整个方法执行完成之后才能出现model视图？？？？
}
// 使用照片
- (void)selectImage {
    
    UIActionSheet *actioonSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actioonSheet showInView:self.view];
    [actioonSheet release];
    
}
- (void)showFaceView {
    [self.textView resignFirstResponder];
    
    if (_faceView == nil) {
        
        __block SendViewController *this = self;
//    _faceView = [[WXFaceScrollerView alloc] initWithFrame:CGRectZero];
        _faceView = [[WXFaceScrollerView alloc] initWithSelectBlock:^(NSString *faceName) {
            NSString *text = this.textView.text;
            NSString *appdenText = [text stringByAppendingString:faceName];
            
            this.textView.text = appdenText;
        }];
    _faceView.top = ScreenHeight - 20 - 44 - _faceView.height;
    _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight- 44-20);
        [self.view addSubview:_faceView];
    }
    
    UIButton *facebtn = [_buttons objectAtIndex:4];
    UIButton *keyBoard =[_buttons objectAtIndex:5];
    facebtn.alpha = 1;
    keyBoard.alpha = 0;
    keyBoard.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform = CGAffineTransformIdentity;
        facebtn.alpha = 0;
        
        // 调整textView  editorBar y坐标
        self.editorBar.bottom = ScreenHeight - _faceView.height-20-44;//减掉状态栏和导航栏的高度
        self.textView.height = self.editorBar.top;

    } completion:^(BOOL finished) {
        // 笑脸淡出，键盘键入
        [UIView animateWithDuration:0.3 animations:^{
            keyBoard.alpha = 1;
        }];
    }];
    
   }

- (void)showKeyBoard {
    [self.textView becomeFirstResponder];
    UIButton *facebtn = [_buttons objectAtIndex:4];
    UIButton *keyBoard =[_buttons objectAtIndex:5];
    keyBoard.alpha = 1;
    facebtn.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight- 44-20);
        keyBoard.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            facebtn.alpha = 1;
        }];
    }];
}

#pragma mark - actions

- (void)imageAction:(UIButton *)btn {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.userInteractionEnabled = YES;// 添加手势事件
        _imageView.contentMode = UIViewContentModeScaleAspectFill;//自适应
        
        UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)];
        [_imageView addGestureRecognizer:tapGestrue];
        [tapGestrue release];
        
        // 创建删除按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(280, 40, 20, 26);
        btn.backgroundColor = [UIColor blackColor];
        btn.tag = 100;
        btn.hidden = YES;
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:btn];
    }
    
    [self.textView resignFirstResponder];// 让键盘消失
    
    // 添加到视图上
    if (![_imageView superview]) {
        _imageView.image = self.sendImage;
        [self.view.window addSubview:_imageView];
            _imageView.frame = CGRectMake(5, ScreenHeight-240, 20, 20);
        [UIView animateWithDuration:0.4 animations:^{
            _imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden = YES;
            [_imageView viewWithTag:100].hidden = NO;
        }];
    }
}

- (void)scaleImageAction:(UITapGestureRecognizer *)tap {
    
    [_imageView viewWithTag:100].hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        _imageView.frame = CGRectMake(5, ScreenHeight-240, 20, 20);
    } completion:^(BOOL finished) {
        [_imageView removeFromSuperview];
    }];
    // 
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.textView becomeFirstResponder];
}

- (void)sendAction {
    // 发送微博
    [self doSendData];
}

- (void)deleteAction:(UIButton *)button {
    // 1.缩小图片。2 删除图片 3 icon未知恢复
    [self scaleImageAction:nil];//缩小图片
    [self.sendImageButton removeFromSuperview];// 移除缩略图
    self.sendImage = nil;//发送图片清空
    
    UIButton *btn1 = [_buttons objectAtIndex:0];
    UIButton *btn2 = [_buttons objectAtIndex:1];
    
    [UIView animateWithDuration:0.5 animations:^{
        // 恢复
        btn1.transform = CGAffineTransformIdentity;
        btn2.transform = CGAffineTransformIdentity;
    }];

}


- (void)buttonAction:(UIButton *)button {
    switch (button.tag) {
        case 10:
        {
            [self location];
            break;
        }case 11:
        {
            [self selectImage];
            break;
        }case 12:
        {
            break;
        }case 13:
        {
            break;
        }case 14:
        {
            [self showFaceView];
            break;
        }case 15:
        {
            [self showKeyBoard];
            break;
        }
    }

}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    switch (buttonIndex) {
        case 0:// 用户拍照
        {
            BOOL isCamer = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (!isCamer) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"伦家找不到摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                return;
            }
            // 拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 1:// 用户相册
        {
            sourceType =UIImagePickerControllerSourceTypePhotoLibrary;// 可以使用所有的相册图片  UIImagePickerControllerSourceTypeSavedPhotosAlbum 只能使用album
            break;
        }
        case 2:
        {
            
            break;
        }
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    
    
    if (self.sendImageButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.frame = CGRectMake(5, 20, 25, 25);
        [btn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton = btn;
    }
    
    [self.sendImageButton setImage:image forState:UIControlStateNormal];
    [self.editorBar addSubview: self.sendImageButton];

    UIButton *btn1 = [_buttons objectAtIndex:0];
    UIButton *btn2 = [_buttons objectAtIndex:1];
    
    [UIView animateWithDuration:0.5 animations:^{
        // 可以恢复
        btn1.transform = CGAffineTransformTranslate(btn1.transform, 20, 0);
        btn2.transform = CGAffineTransformTranslate(btn2.transform, 5, 0);
    }];
   
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - NSNotification
- (void)keyboardShowNotification:(NSNotification *)notification {

    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    float height = frame.size.height;
    
    self.editorBar.bottom = ScreenHeight - height-20-44;//减掉状态栏和导航栏的高度
    self.textView.height = self.editorBar.top;
    
}

#pragma mark - textField delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self showKeyBoard];// 显示键盘
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_faceView release];
    [_textView release];
    [_editorBar release];
    [_placeView release];
    [_placeBackgroundView release];
    [_placeLabel release];
    [_buttons release];
    [super dealloc];
}
@end
