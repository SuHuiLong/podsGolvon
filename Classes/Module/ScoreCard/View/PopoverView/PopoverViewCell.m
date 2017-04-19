//
//  PopoverViewCell.m
//  Popover
//
//  Created by StevenLee on 2017/1/4.
//  Copyright © 2017年 StevenLee. All rights reserved.
//

#import "PopoverViewCell.h"

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

- (void)setAction:(PopoverAction *)action {
    _titleLabel.text = action.title;
    _selectedImgView.hidden= !action.isSelected;
}

@end
