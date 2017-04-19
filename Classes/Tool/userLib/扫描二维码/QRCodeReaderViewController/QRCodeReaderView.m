
#import "QRCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>



#define ScreenSize [UIScreen mainScreen].bounds.size
#define ScreenWidth ScreenSize.width
#define ScreenHeight ScreenSize.height
// 宽的左侧比例计算:在()中填入比例:(例) %10 -填-> 10
#define WScale(M) ScreenWidth*M/100
// 宽的右侧比例计算:在()中填入比例:(例) %10 -填-> 10
#define RWScale(M) ScreenWidth*(1-M/100)
// 高的上侧比例计算:在()中填入比例:(例) %10 -填-> 10
#define HScale(M) ScreenHeight*M/100
// 高的下侧比例计算:在()中填入比例:(例) %10 -填-> 10
#define RHScale(M) ScreenHeight(1-M/100)
//字体
#define kHorizontal(Z) ((Z)/375.0*([UIScreen mainScreen].bounds.size.width))

//字体和图片
#define Font(...)  [Global FontRegular:(__VA_ARGS__)]
#define FontBold(...)  [Global FontSemibold:(__VA_ARGS__)]
#define FontLigth(...) [Global FontLight:(__VA_ARGS__)]


#define ImageName(...) [UIImage imageNamed:(__VA_ARGS__)]

//颜色
#define GPRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1]
#define GPColor(r, g, b) GPRGBAColor((r), (g), (b),255)
#define GPGrayColor(v) CTColor((v)


@interface QRCodeReaderView ()
{
    __weak id<QRCodeReaderViewDelegate> delegate;
    CGRect       innerViewRect;
    
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation QRCodeReaderView
@synthesize innerViewRect,delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect
{
    
//    CGRect innerRect = CGRectInset(rect,WScale(15) , WScale(15));
    CGRect innerRect = CGRectMake(WScale(15), HScale(23.5), WScale(70), WScale(70));

    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   +=  WScale(15);
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y   += (rect.size.height - minSize) / 2 - rect.size.height / 6;
        innerRect.size.height = minSize;
    }
    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
    
    innerViewRect = offsetRect;
    if(delegate)
    {
        [delegate loadView:innerViewRect];
    }
    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
    
    [self addOtherLay:offsetRect];
}

#pragma mark - Private Methods

- (void)addOverlay
{
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor redColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor lightGrayColor].CGColor;
    _overlay.lineWidth       = 1;
    _overlay.lineDashPattern = @[@50,@0];
    _overlay.lineDashPhase   = 1;
    _overlay.opacity         = 0.5;
    [self.layer addSublayer:_overlay];
}

- (void)addOtherLay:(CGRect)rect
{
    CAShapeLayer* layerTop   = [[CAShapeLayer alloc] init];
    layerTop.fillColor       = [UIColor blackColor].CGColor;
    layerTop.opacity         = 0.5;
    layerTop.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.origin.y)].CGPath;
    [self.layer addSublayer:layerTop];
    
    CAShapeLayer* layerLeft   = [[CAShapeLayer alloc] init];
    layerLeft.fillColor       = [UIColor blackColor].CGColor;
    layerLeft.opacity         = 0.5;
    layerLeft.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y,  WScale(15), [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerLeft];
    
    CAShapeLayer* layerRight   = [[CAShapeLayer alloc] init];
    layerRight.fillColor       = [UIColor blackColor].CGColor;
    layerRight.opacity         = 0.5;
    layerRight.path            = [UIBezierPath bezierPathWithRect:CGRectMake([UIScreen mainScreen].bounds.size.width -  WScale(15), rect.origin.y,  WScale(15), [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerRight];
    
    CAShapeLayer* layerBottom   = [[CAShapeLayer alloc] init];
    layerBottom.fillColor       = [UIColor blackColor].CGColor;
    layerBottom.opacity         = 0.5;
    layerBottom.path            = [UIBezierPath bezierPathWithRect:CGRectMake( WScale(15), rect.origin.y + rect.size.height, [UIScreen mainScreen].bounds.size.width -  WScale(30), [UIScreen mainScreen].bounds.size.height - rect.origin.y - rect.size.height)].CGPath;
    [self.layer addSublayer:layerBottom];

}
@end
