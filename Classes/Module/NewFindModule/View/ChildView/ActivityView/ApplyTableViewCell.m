//
//  ApplyTableViewCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ApplyTableViewCell.h"

@interface ApplyTableViewCell ()<UITextFieldDelegate>

@end

@implementation ApplyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

-(void)createCell{
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.frame = CGRectMake(kWvertical(14), 0, kWvertical(300), kHvertical(38));
    _typeLabel.textColor = textTintColor;
    _typeLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_typeLabel];
    
    _contentField = [[UITextField alloc] init];
    _contentField.frame = CGRectMake(kWvertical(87), 0, kWvertical(300), kHvertical(38));
    _contentField.textColor = deepColor;
    _contentField.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_contentField];
}
@end
