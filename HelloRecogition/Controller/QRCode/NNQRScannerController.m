//
//  NNQRScannerController.m
//  NNLetter
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNQRScannerController.h"
#import "NNScanVideoZoomView.h"
#import "NNCommonPermission.h"
#import "NNPermissionSetting.h"
#import "NNFactory.h"
#import "NNImageChooseObject.h"
#import "TZImagePickerController.h"
#import "UIViewController+NNPopQrCode.h"

@interface NNQRScannerController ()
/**
 视频显示区域
 */
@property (nonatomic, strong) NNScanVideoZoomView *zoomView;
/**
 相册
 */
@property (nonatomic, strong) UIBarButtonItem *photoBBI;

// - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;

//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

/**
 扫描失败提示
 */
@property (nonatomic, strong) UIButton *failureBtn;

//光线第一次变暗
@property (nonatomic, getter=isFirstBecomeDark) BOOL firstBecomeDark;

@end

@implementation NNQRScannerController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingUpNavigation];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.barStyle = NNNavigationBarTransparentDark;
    self.navigationBarColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.navigationBarTitleColor = [UIColor whiteColor];
    self.navigationTintColor = [UIColor whiteColor];
    [self setBackButtonImage:[UIImage imageNamed:@"nav-fanhui_baise"]];
    [self drawBottomItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessor
- (NNScanVideoZoomView *)zoomView
{
    if (!_zoomView)
    {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[NNScanVideoZoomView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        @weakify(self);
        _zoomView.block= ^(float value)
        {
            @strongify(self);
            [self.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}

- (UIBarButtonItem *)photoBBI{
    if (_photoBBI == nil) {
        _photoBBI = [NNFactory createTitleActionBarButton:@"相册" titleColor:[UIColor whiteColor] ItemWithTarget:self action:@selector(openPhoto)];
    }
    return _photoBBI;
}

- (UIButton *)failureBtn{
    if (_failureBtn == nil) {
        CGRect coreRect = [NNScanView nn_getScanCoreRectWithPreView:self.view style:self.style];
        _failureBtn = [[UIButton alloc] initWithFrame:coreRect];
        [_failureBtn setTitle:@"未发现二维码\n轻触屏幕重新扫描" forState:UIControlStateNormal];
        [_failureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _failureBtn.titleLabel.numberOfLines = 0;
        _failureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_failureBtn addTarget:self action:@selector(reStartDevice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failureBtn;
}

#pragma mark - Action
- (void)tap{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)reStartDevice{
    [super reStartDevice];
    if (_failureBtn) {
        [_failureBtn removeFromSuperview];
        self.failureBtn = nil;
    }
}

//打开相册
- (void)openPhoto{
    @weakify(self);
    [NNCommonPermission authorizeWithType:NNPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        @strongify(self);
        if (granted) {
            [self reStartDevice];
            [self openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [NNPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash:(UIButton *)btn{
    [self switchTorch:!btn.isSelected];
}

- (void)myQRCode{
    
}

#pragma mark ------------------- Privacy ----------------------
- (void)settingUpNavigation{
    self.pageID = kScan_Page;
    self.barStyle = NNNavigationBarTransparentDark;
    self.navigationBarColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.navigationBarTitleColor = [UIColor whiteColor];
    self.navigationTintColor = [UIColor whiteColor];
    [self setBackButtonImage:[UIImage imageNamed:@"nav-fanhui_baise"]];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.photoBBI;
    _firstBecomeDark = YES;
    
    //设置扫码后需要扫码图像
//    self.needScanImage = YES;
    self.videoZoom = YES;
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        CGRect coreRect = [NNScanView nn_getScanCoreRectWithPreView:self.view style:self.style];
        _topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-120, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetMaxY(coreRect)+_topTitle.height/2.0 +10);
        _topTitle.font = [UIFont systemFontOfSize:12];
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetMaxY(coreRect)+_topTitle.height/2.0 +10);
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将二维码放入框内，即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

//- (void)cameraInitOver
//{
//    if (self.isVideoZoom) {
//        [self zoomView];
//    }
//}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    CGRect coreRect = [NNScanView nn_getScanCoreRectWithPreView:self.view style:self.style];
    _bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coreRect)+70,
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    _btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateSelected];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash:) forControlEvents:UIControlEventTouchUpInside];
    _btnFlash.hidden = YES;
    [_bottomItemsView addSubview:_btnFlash];
}

- (void)scanResultWithArray:(NSArray<NNScannerResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (NNScannerResult *result in array) {
        
        NSLog(@"scanResult:%@",result.scannedString);
    }
    
    NNScannerResult *scanResult = array[0];
    
    NSString *strResult = scanResult.scannedString;
    
    self.scanImage = scanResult.scanedImage;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //声音提醒,系统音效id 1114
//    [APP playBeepPlayer];
    [APP playSystemSound:1114];
    [self showNextVCWithScanResult:scanResult];
    
}

//扫码失败提示内容
- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"未发现二维码\n轻触屏幕重新扫描";
    }
    
    NSLog(@"%@", strResult);
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.view addSubview:self.failureBtn];
        [self stopScan];
        [self.qRScanView stopScanAnimation];
    });
}

//扫描成功
- (void)showNextVCWithScanResult:(NNScannerResult *)strResult
{
    NSLog(@">>扫描内容: --%@", strResult.scannedString);
    if (strResult && strResult.scannedString) {
        [self qrCodeFinished:strResult.scannedString  isPushController:YES];
    }
}

- (void)openLocalPhoto:(BOOL)allowsEditing{
    [MobClick event:kScan_Photoalbum_Event];
    @weakify(self);
    [NNImageChooseObject gotoChooseQRCodeImageFrom:self complete:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
        [selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
            [selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                UIImage *srcImage = obj;
                if (srcImage) {
                    [self pickerImageResultWith:srcImage];
                }else{
                    [Tooltip showMessage:@"未发现二维码"];
                }
                
                *stop = YES;
                
            }];
        }];
    }];
}

- (void)pickerImageResultWith:(UIImage *)srcImage {
    @weakify(self);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        [NNQRCodeScanner recognizeImage:srcImage success:^(NSArray<NNScannerResult *> *array) {
            @strongify(self);
            [self scanResultWithArray:array];
        }];
    }
    else
    {
        [Tooltip showView:@"低于ios8.0系统不支持识别图片条码"];
    }
}

- (void)switchTorch:(BOOL)on
{
    //更换按钮状态
    _btnFlash.selected = on;
//    _tipLabel.text = [NSString stringWithFormat:@"轻触%@", on?@"关闭":@"照亮"];
    [super openOrCloseFlash];
}

#pragma mark - NNQRCodeScannerDelegate
- (void)switchTorchBtnState:(BOOL)show{
    self.btnFlash.hidden = !show && !self.btnFlash.isSelected;
    if (show) {
        if (self.isFirstBecomeDark) {
            CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animate.fromValue = @(1);
            animate.toValue = @(0);
            animate.duration = .6;
            animate.repeatCount = 2;
            [self.btnFlash.layer addAnimation:animate forKey:nil];
            self.firstBecomeDark = NO;
        }
    }
    else
    {
        
    }
}

@end
