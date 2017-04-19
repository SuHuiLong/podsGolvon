//
//  GolfersTableViewCell.m
//  podsGolvon
//
//  Created by apple on 2016/10/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "GolfersTableViewCell.h"
#import "Factory.h"
@implementation GolfersTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}


-(void)createView{
    _headerImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(13), kHvertical(9), kHvertical(28), kHvertical(28)) Image:[UIImage imageNamed:@"EmojiKeybord"]];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = kHvertical(14);
    
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(_headerImageView.x_width+kWvertical(8), 0, ScreenWidth - _headerImageView.x_width - kWvertical(60), kHvertical(45)) textColor:BlackColor fontSize:kHorizontal(14.0f) Title:@"测试用户"];
    _phoneLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, kHvertical(45)) textColor:rgba(137,138,145,1) fontSize:kHorizontal(12) Title:nil];
    
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(ScreenWidth  - kWvertical(19) - kHvertical(20) - kWvertical(10), 0, kHvertical(20) + kWvertical(20), kHvertical(20) + kHvertical(26));
    
    _selectBtn.contentEdgeInsets = UIEdgeInsetsMake(kHvertical(13), kWvertical(10), kHvertical(13), kWvertical(10));
    
    [_selectBtn setImage:[UIImage imageNamed:@"scoring球友勾选－默认"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"scoring球友勾选－点击"] forState:UIControlStateSelected];
    
    _line = [Factory createViewWithBackgroundColor:rgba(225,226,228,1) frame:CGRectMake(kWvertical(13), self.height-0.5,ScreenWidth-kWvertical(13) , 0.5)];

    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_phoneLabel];
    [self.contentView addSubview:_selectBtn];
}


-(void)configModel:(GolfersModel *)model{
    NSString *imageUrl = model.avator;
    NSString *nickname = model.nickname;
    BOOL isSelect = model.isSelect;
    if (isSelect) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [_nameLabel setText:nickname];
}


-(void)configParkModel:(UserBallParkModel *)model{
    self.backgroundColor = WhiteColor;
    _selectBtn.hidden = YES;
    _nameLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y, ScreenWidth - _nameLabel.x - kWvertical(18), _nameLabel.height);
    _nameLabel.text = model.qname;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.qlogo]];
    
}


-(void)configAddressModel:(PPPersonModel *)model{
    _headerImageView.hidden = YES;
    _phoneLabel.hidden = NO;

    BOOL isSelect = model.isSelect;
    if (isSelect) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    _nameLabel.x = kWvertical(13);
    _nameLabel.text = model.name;
    
    [_nameLabel sizeToFitSelf];
    
    _phoneLabel.x = _nameLabel.x_width;
    NSString *nameStr = [NSString string];
    if (model.mobileArray.count>0) {
        nameStr = model.mobileArray[0];
    }
    
    _phoneLabel.text = [NSString stringWithFormat:@"(%@)",nameStr];
    
    
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
