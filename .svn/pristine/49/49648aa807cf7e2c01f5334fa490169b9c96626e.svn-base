


#import "QRCodeReaderViewController.h"
#import "QRCameraSwitchButton.h"
#import "QRCodeReaderView.h"
#import "rotationView.h"
#import "SignUpViewController.h"


@interface QRCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate,QRCodeReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) AVAudioPlayer        *beepPlayer;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) UIImageView          *imgLine;
@property (strong, nonatomic) UILabel              *lblTip;
@property (strong, nonatomic) NSTimer              *timerScan;

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureDevice            *frontDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *frontDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) CIDetector *detector;

@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end

@implementation QRCodeReaderViewController

- (id)init
{
    NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
    _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    return [self initWithCancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];

        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        [self setupAutoLayoutConstraints];

        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButton:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBarHidden = YES;
    [self startScanning];
    
    self.tabBarController.tabBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

  [self stopScanning];
  [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = false;
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  _previewLayer.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate
{
  return YES;
}

- (void)scanAnimate
{
    _imgLine.frame = CGRectMake(WScale(15), _cameraView.innerViewRect.origin.y, WScale(70), 1.5);
    [UIView animateWithDuration:2 animations:^{
        _imgLine.frame = CGRectMake(_imgLine.frame.origin.x, _imgLine.frame.origin.y + _cameraView.innerViewRect.size.height - 6, _imgLine.frame.size.width, _imgLine.frame.size.height);
    }];
}

- (void)loadView:(CGRect)rect
{
    _imgLine.frame = CGRectMake(0, _cameraView.innerViewRect.origin.y, ScreenWidth, 12);
    [self scanAnimate];
}

#pragma mark - Managing the Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  
  [_cameraView setNeedsDisplay];
  
  if (self.previewLayer.connection.isVideoOrientationSupported) {
    self.previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:toInterfaceOrientation];
  }
}

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  switch (interfaceOrientation) {
    case UIInterfaceOrientationLandscapeLeft:
      return AVCaptureVideoOrientationLandscapeLeft;
    case UIInterfaceOrientationLandscapeRight:
      return AVCaptureVideoOrientationLandscapeRight;
    case UIInterfaceOrientationPortrait:
      return AVCaptureVideoOrientationPortrait;
    default:
      return AVCaptureVideoOrientationPortraitUpsideDown;
  }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    _cameraView.delegate                                  = self;
    [self.view addSubview:_cameraView];

    if (_frontDevice) {
        [_switchCameraButton setTranslatesAutoresizingMaskIntoConstraints:false];
        [_switchCameraButton addTarget:self action:@selector(switchCameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchCameraButton];
    }

    self.cancelButton                                       = [[UIButton alloc] init];
    self.cancelButton.hidden                                = YES;
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    
    
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"白色统一返回"] target:self selector:@selector(popBack) Title:nil];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 33)];
    [self.view addSubview:leftBtn];
    
    
    
    UILabel *titleLabel =  [Factory createLabelWithFrame:CGRectMake(0, 30, self.view.width, kHvertical(25)) textColor:WhiteColor fontSize:kHvertical(18) Title:@"扫一扫"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    
    CGFloat c_width = ScreenWidth - WScale(30);
//    CGFloat s_height = mainHeight - WScale(15);
    CGFloat y = HScale(23.5);
    
    _lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0,HScale(25.4)+WScale(70)+HScale(3.1), ScreenWidth, HScale(3.3))];
    _lblTip.text = @"我的二维码";
     _lblTip.textColor = rgba(53,141,227,1);

    _lblTip.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _lblTip.textAlignment = NSTextAlignmentCenter;
    _lblTip.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PustToPrentSelf)];
    [_lblTip addGestureRecognizer:tpg];
    
    [self.view addSubview:_lblTip];
    
    
    CGFloat corWidth = 16;
    
    UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(15), y+corWidth-1, corWidth, corWidth)];
    img1.image = [UIImage imageNamed:@"左上角"];
    [self.view addSubview:img1];
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(c_width - corWidth + WScale(15), y+corWidth-1, corWidth, corWidth)];
    img2.image = [UIImage imageNamed:@"右上角"];

    [self.view addSubview:img2];
    
    
    
    
    UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(15), y + WScale(70)-1, corWidth, corWidth)];
    img3.image = [UIImage imageNamed:@"左下角"];

    [self.view addSubview:img3];
    
    UIImageView* img4 = [[UIImageView alloc] initWithFrame:CGRectMake(  c_width - corWidth+WScale(15), y + WScale(70)-1 , corWidth, corWidth)];
    img4.image = [UIImage imageNamed:@"右下角"];

    [self.view addSubview:img4];
    
    
    _imgLine = [[UIImageView alloc] init];
    _imgLine.image = [UIImage imageNamed:@"扫描线"];
    [self.view addSubview:_imgLine];
    
    
    
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(31), HScale(93.4), WScale(37.9), HScale(4.2))];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = bottomView.frame.size.height/2;
    bottomView.backgroundColor = rgba(53,141,227,1);
//    bottomView.alpha = 0.6;
    [self.view addSubview:bottomView];
//    rotationView *ScrollView = [[rotationView alloc] initWithFrame:CGRectMake(WScale(33.1), HScale(94.4), WScale(4.8), HScale(2.2))];
    UIImageView *ScrollView = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(33.1), HScale(94.4), WScale(4.8), HScale(2.2))];
    ScrollView.image = [UIImage imageNamed:@"扫描中"];
    ScrollView.userInteractionEnabled = NO;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotationAnim = [CABasicAnimation animation];
        rotationAnim.keyPath = @"transform.rotation.z";
        rotationAnim.toValue = @(2 * M_PI);
        rotationAnim.repeatCount = MAXFLOAT;
        rotationAnim.duration = 5;
        rotationAnim.cumulative = NO;
        rotationAnim.autoreverses = NO;
        [ScrollView.layer addAnimation:rotationAnim forKey:nil];
    });

    
    
    [self.view addSubview:ScrollView];
    
    
    
//    [ScrollView rotate360WithDuration:2 repeatCount:300 timingMode:i7Rotate360TimingModeLinear];
    
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(WScale(40.5), HScale(94), WScale(30), HScale(3))];
    
    bottomLabel.text = @"正在扫描二维码";
    bottomLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    bottomLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomLabel];
    
}

-(void)pushSelf:(UIButton *)btn{

    
}

-(void)PustToPrentSelf{
}



#pragma mark - pop返回
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupAutoLayoutConstraints
{
  NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
  
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(0)]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
  
  if (_switchCameraButton) {
    NSDictionary *switchViews = NSDictionaryOfVariableBindings(_switchCameraButton);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchCameraButton(50)]" options:0 metrics:nil views:switchViews]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchCameraButton(70)]|" options:0 metrics:nil views:switchViews]];
  }
}

- (void)setupAVComponents
{
  self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  if (_defaultDevice) {
    self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
    self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
    self.session            = [[AVCaptureSession alloc] init];
    self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
      if (device.position == AVCaptureDevicePositionFront) {
        self.frontDevice = device;
      }
    }
    
    if (_frontDevice) {
      self.frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:nil];
    }
  }
}

- (void)configureDefaultComponents
{
  [_session addOutput:_metadataOutput];
  
  if (_defaultDeviceInput) {
    [_session addInput:_defaultDeviceInput];
  }
  
  [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
    [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
  }
  [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  
  if ([_previewLayer.connection isVideoOrientationSupported]) {
    
      _previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:self.interfaceOrientation];
    
  }
}

- (void)switchDeviceInput
{
  if (_frontDeviceInput) {
    [_session beginConfiguration];
    
    AVCaptureDeviceInput *currentInput = [_session.inputs firstObject];
    [_session removeInput:currentInput];
    
    AVCaptureDeviceInput *newDeviceInput = (currentInput.device.position == AVCaptureDevicePositionFront) ? _defaultDeviceInput : _frontDeviceInput;
    [_session addInput:newDeviceInput];
    
    [_session commitConfiguration];
  }
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
  [self stopScanning];
  
  if (_completionBlock) {
    _completionBlock(nil);
  }
  
  if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
    [_delegate readerDidCancel:self];
  }
}

- (void)switchCameraAction:(UIButton *)button
{
  [self switchDeviceInput];
}

#pragma mark - Controlling Reader

- (void)startScanning;
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
    
    _timerScan = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanAnimate) userInfo:nil repeats:YES];
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];

            [self stopScanning];
            
            if (_completionBlock) {
                [_beepPlayer play];
                DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
                NSDictionary *dict = @{
                                       @"name_id":userDefaultId,
                                       @"qr":scannedResult
                                       };
                
                [manager downloadWithUrl:[NSString stringWithFormat:@"%@scoreapi.php?func=scanadd",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
                    SignUpViewController *vc = [[SignUpViewController alloc] init];
                    NSLog(@"%@",data);
                    NSString *code = [NSString string];
                    code = @"1";
                    if (success) {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            NSArray *list = [data objectForKey:@"list"];
                            if (list.count>0) {
                                [self.navigationController pushViewController:vc animated:YES];
                                return ;
                            }
                            code = [data objectForKey:@"code"];
                        }
                    }
                    _completionBlock(code);
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }];
                
            }

            if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [_delegate reader:self didScanResult:scannedResult];
            }

            
            break;
        }
    }
}

#pragma mark - Checking the Metadata Items Types

+ (BOOL)isAvailable
{
  @autoreleasepool {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!captureDevice) {
      return NO;
    }
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!deviceInput || error) {
      return NO;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
      return NO;
    }
    
    return YES;
  }
}

#pragma mark - Checking RightBarButtonItem
-(void)clickRightBarButton:(UIBarButtonItem*)item
{
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate&&识别照片
- ( void )imagePickerController:( UIImagePickerController *)picker didFinishPickingMediaWithInfo:( NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]
    //                                               options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:1]}];
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        if (_completionBlock) {
            [_beepPlayer play];
            _completionBlock(scannedResult);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [_delegate reader:self didScanResult:scannedResult];
        }
    }
}




@end
