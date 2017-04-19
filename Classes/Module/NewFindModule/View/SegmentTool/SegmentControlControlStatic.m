//
//  SegmentControlControlStatic.m
//  FindModule
//
//  Created by apple on 2016/12/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SegmentControlControlStatic.h"
#import "UIView+Size.h"
#import "SegmentButton.h"


//颜色
#define GPRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1]
#define GPColor(r, g, b) GPRGBAColor((r), (g), (b),255)
#define localColor GPColor(53, 141, 227)
#define textTintColor  GPColor(137, 138, 145)
#define kHorizontal(Z) ((Z)/375.0*([UIScreen mainScreen].bounds.size.width))


@interface SegmentControlControlStatic ()

/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 带有图片的标题按钮 */
@property (nonatomic, strong) SegmentButton *image_title_btn;
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 普通状态下的图片数组 */
@property (nonatomic, strong) NSArray *nomal_image_Arr;
/** 选中状态下的图片数组 */
@property (nonatomic, strong) NSArray *selected_image_Arr;
/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation SegmentControlControlStatic

/** 按钮字体的大小(字号) */
static CGFloat const btn_fondOfSize = 17;
/** 指示器的高度 */
static CGFloat const indicatorViewHeight = 2;
/** 点击按钮时, 指示器的动画移动时间 */
static CGFloat const indicatorViewTimeOfAnimation = 0.15;


- (NSMutableArray *)storageAlltitleBtn_mArr {
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle{
    
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        
        self.delegate = delegate;
        
        self.title_Arr = childVcTitle;
        
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate childVcTitle:(NSArray *)childVcTitle{
    return [[self alloc] initWithFrame:frame delegate:delegate childVcTitle:childVcTitle];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = delegate;
        self.nomal_image_Arr = nomalImageArr;
        self.selected_image_Arr = selectedImageArr;
        self.title_Arr = childVcTitle;
        
        [self setupSubviewsWithImage];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<SegmentControlControlStaticDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    return [[self alloc] initWithFrame:frame delegate:delegate nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr childVcTitle:childVcTitle];
}

- (void)setupSubviews {
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat button_X = 0;
    CGFloat button_Y = 10;
    CGFloat button_W = scrollViewWidth / _title_Arr.count;
    CGFloat button_H = self.frame.size.height;
    
    for (NSInteger i = 0; i < _title_Arr.count; i++) {
        // 创建静止时的标题button
        self.title_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
        _title_btn.tag = i;
        
        // 计算title_btn的x值
        button_X = i * button_W;
        _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:textTintColor forState:(UIControlStateNormal)];
        [_title_btn setTitleColor:localColor forState:(UIControlStateSelected)];
        
        // 点击事件
        [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 默认选中第0个button
        if (i == 0) {
            [self buttonAction:_title_btn];
        }
        
        // 存入所有的title_btn
        [self.storageAlltitleBtn_mArr addObject:_title_btn];
        [self addSubview:_title_btn];
    }
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = localColor;
    _indicatorView.height = indicatorViewHeight;
    _indicatorView.top = self.frame.size.height - 2 * indicatorViewHeight;
    [self addSubview:_indicatorView];
    
    // 指示器默认在第一个选中位置
    // 计算Titlebutton内容的Size
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    _indicatorView.width = buttonSize.width;
    _indicatorView.centerX = firstButton.centerX;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setupSubviewsWithImage {
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat button_X = 0;
    CGFloat button_Y = 0;
    CGFloat button_W =
    scrollViewWidth / _title_Arr.count;
    CGFloat button_H = self.frame.size.height;
    
    for (NSInteger i = 0; i < _title_Arr.count; i++) {
        // 创建静止时的标题button
        self.image_title_btn = [[SegmentButton alloc] init];
        
        _image_title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fondOfSize];
        _image_title_btn.tag = i;
        
        // 计算title_btn的x值
        button_X = i * button_W;
        _image_title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_image_title_btn setTitle:_title_Arr[i] forState:(UIControlStateNormal)];
        [_image_title_btn setTitleColor:textTintColor forState:(UIControlStateNormal)];
        [_image_title_btn setTitleColor:localColor forState:(UIControlStateSelected)];
        [_image_title_btn setImage:[UIImage imageNamed:_nomal_image_Arr[i]] forState:(UIControlStateNormal)];
        [_image_title_btn setImage:[UIImage imageNamed:_selected_image_Arr[i]] forState:(UIControlStateSelected)];
        
        // 点击事件
        [_image_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // 默认选中第0个button
        if (i == 0) {
            [self buttonAction:_image_title_btn];
        }
        
        // 存入所有的title_btn
        [self.storageAlltitleBtn_mArr addObject:_image_title_btn];
        [self addSubview:_image_title_btn];
    }
    
    // 取出第一个子控件
    UIButton *firstButton = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = localColor;
    _indicatorView.height = indicatorViewHeight;
    _indicatorView.top = self.frame.size.height - indicatorViewHeight;
    [self addSubview:_indicatorView];
    
    // 指示器默认在第一个选中位置
    // 计算Titlebutton内容的Size
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    _indicatorView.width = buttonSize.width;
    _indicatorView.centerX = firstButton.centerX;
}

#pragma mark - - - 按钮的点击事件
- (void)buttonAction:(UIButton *)sender {
    // 1、代理方法实现
    NSInteger index = sender.tag;
    if ([self.delegate respondsToSelector:@selector(SGSegmentedControlStatic:didSelectTitleAtIndex:)]) {
        [self.delegate SGSegmentedControlStatic:self didSelectTitleAtIndex:index];
    }
    
    // 2、改变选中的button的位置
    [self selectedBtnLocation:sender];
}

/** 标题选中颜色改变以及指示器位置变化 */
- (void)selectedBtnLocation:(UIButton *)button {
    
    // 1、选中的button
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(indicatorViewTimeOfAnimation * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_temp_btn == nil) {
            button.selected = YES;
            _temp_btn = button;
        }else if (_temp_btn != nil && _temp_btn == button){
            button.selected = YES;
        }else if (_temp_btn != button && _temp_btn != nil){
            _temp_btn.selected = NO;
            button.selected = YES; _temp_btn = button;
        }
    });
    
    // 2、改变指示器的位置
    // 改变指示器位置
    [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
        // 计算内容的Size
        CGSize buttonSize = [self sizeWithText:button.titleLabel.text font:[UIFont systemFontOfSize:btn_fondOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorViewHeight)];
        self.indicatorView.width = buttonSize.width;
        self.indicatorView.centerX = button.centerX;
    }];
}

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}


#pragma mark - - - setter 方法设置属性
- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    _titleColorStateNormal = titleColorStateNormal;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    _titleColorStateSelected = titleColorStateSelected;
    for (UIView *subViews in self.storageAlltitleBtn_mArr) {
        UIButton *button = (UIButton *)subViews;
        [button setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicatorView.backgroundColor = indicatorColor;
}

- (void)setShowsBottomScrollIndicator:(BOOL)showsBottomScrollIndicator {
    if (self.showsBottomScrollIndicator == YES) {
        
    } else {
        [self.indicatorView removeFromSuperview];
    }
}

@end
