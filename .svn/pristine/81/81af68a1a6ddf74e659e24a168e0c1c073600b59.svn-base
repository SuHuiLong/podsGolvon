//
//  NewStartScrolTableViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/10/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewStartScrolTableViewCell.h"

@implementation NewStartScrolTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = rgba(255,255,255,1);
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(23), kHvertical(13), ScreenWidth- kWvertical(46), kHvertical(20)) textColor:rgba(53,54,56,1) fontSize:kHorizontal(14.0f) Title:nil];
    _titleLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_titleLabel];
    
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(0, kHvertical(45)-0.5, ScreenWidth, 0.5)];
    [self.contentView addSubview:lineView];
    
}


-(void)configParkData:(NearParkModel *)model{
    _titleLabel.text = model.qname;

}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
