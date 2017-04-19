//
//  PopoverView.m
//  Popover
//
//  Created by StevenLee on 2017/1/4.
//  Copyright © 2017年 StevenLee. All rights reserved.
//

#import "PopoverView.h"

static float const kPopoverViewMargin = 8.f; ///< 边距
static float const kPopoverViewCellMargin = 30.f; ///< cell内容左右空白边距
static float const kPopoverViewCellHeight = 44.f; ///< cell指定高度
static float const kPopoverViewArrowHeight = 10.f; ///< 箭头高度

// convert degrees to radians
float popoverView_degreesToRadians(float angle) {
    return angle*M_PI/180;
}

@interface PopoverView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层

#pragma mark - Data
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) void(^handler)(NSUInteger selectedIndex);
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度

@end

@implementation PopoverView

#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, kPopoverViewArrowHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight);
}

#pragma mark - Setter
- (void)setHideAfterTouchOutside:(BOOL)hideAfterTouchOutside {
    _hideAfterTouchOutside = hideAfterTouchOutside;
    _shadeView.userInteractionEnabled = _hideAfterTouchOutside;
}

#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    _titles = @[];
    _hideAfterTouchOutside = YES;
    
    // current view
    self.backgroundColor = [UIColor whiteColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
    [_shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

/*! @brief 显示弹窗指向某个点,  */
- (void)showToPoint:(CGPoint)toPoint {
    NSAssert(_titles.count > 0, @"titles must not be nil or empty !");
    
    // 截取弹窗时相关数据
    float arrowWidth = 20.f; // 箭头宽度
    float cornerRadius = 5.f; // 四角圆角半径
    float arrowCornerRadius = 1.8f; // 箭头顶端半径
    float arrowBottomCornerRadius = 2.5f; // 箭头底部左右两脚的圆角
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (_windowWidth - toPoint.x < minHorizontalEdge) {
        toPoint.x = _windowWidth - minHorizontalEdge;
    }
    
    // 遮罩层
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat currentH = _tableView.contentSize.height + kPopoverViewArrowHeight;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _windowHeight - toPoint.y - kPopoverViewMargin;
    if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
    }
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (_windowWidth - toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), 0); // 箭头顶点在当前视图的坐标
    CGFloat maskTop = kPopoverViewArrowHeight; // 顶部Y值
    CGFloat maskBottom = currentH; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:popoverView_degreesToRadians(180)
                      endAngle:popoverView_degreesToRadians(270)
                     clockwise:YES];
    // 箭头位置
    [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverViewArrowHeight)];
    [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
                     controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
    [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
                     controlPoint:arrowPoint];
    [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)
                     controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:popoverView_degreesToRadians(270)
                      endAngle:popoverView_degreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:popoverView_degreesToRadians(0)
                      endAngle:popoverView_degreesToRadians(90)
                     clockwise:YES];
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:popoverView_degreesToRadians(90)
                      endAngle:popoverView_degreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 添加到keyWindow上
    [_keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, 0.f); // 更改锚点为箭头顶部, 用于从箭头顶部放大.
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
    }];
}

/*! @brief 计算最大宽度 */
- (CGFloat)calculateMaxWidth {
    CGFloat maxWidth = 0.f;
    UIFont *titleFont = [PopoverViewCell titleFont];
    for (NSString *title in _titles) {
        CGFloat titleWidth;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { // iOS7及往后版本
            titleWidth = [title sizeWithAttributes:@{NSFontAttributeName : titleFont}].width;
        } else { // iOS6
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            titleWidth = [title sizeWithFont:titleFont].width;
#pragma GCC diagnostic pop
        }
        
        CGFloat contentWidth = kPopoverViewCellMargin*2 + titleWidth;
        if (contentWidth > maxWidth) {
            maxWidth = contentWidth;
        }
    }
    
    // 如果最大宽度大于(窗口宽度 - kPopoverViewMargin*2)则限制最大宽度等于(窗口宽度 - kPopoverViewMargin*2)
    if (maxWidth > CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2) {
        maxWidth = CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2;
    }
    
    return ceil(maxWidth); // 进一取整数
}

/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Public
+ (instancetype)popoverView {
    return [[self alloc] init];
}

/*! @brief 指向指定的点来显示弹窗 */
- (void)showToPoint:(CGPoint)toPoint withTitles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex handler:(void(^)(NSUInteger selectedIndex))handler {
    _titles = [titles copy];
    _handler = [handler copy];
    [self showToPoint:toPoint];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopoverViewCellHeight;
}

static NSString *kPopoverCellIdentifier = @"kPopoverCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellIdentifier];
    if (!cell) {
        cell = [[PopoverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopoverCellIdentifier];
    }
    [cell setTitle:_titles[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        _handler ? _handler(indexPath.row) : NULL;
        _handler = NULL;
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end



#pragma mark - Custom Cell
@interface PopoverViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *selectedImgView;

@end

@implementation PopoverViewCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // initialize
    [self initialize];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedImgView.hidden= !selected;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.backgroundColor =[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.contentView.backgroundColor = self.backgroundColor;
        }];
    }
}

#pragma mark - Private
// 初始化
- (void)initialize {
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [PopoverViewCell titleFont];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    // Constraint
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    // 选中的图片标识
    UIImageView *selectedImgView = [[UIImageView alloc] init];
    selectedImgView.image = [UIImage imageNamed:@"PopoverView.bundle/popover_selected"];
    selectedImgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:selectedImgView];
    _selectedImgView = selectedImgView;
    // Constraint
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:selectedImgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1.f constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:selectedImgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
}

#pragma mark - Public
/*! @brief 标题字体 */
+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:15.f];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end

