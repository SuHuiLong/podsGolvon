//
//  PublicBenefitTableViewCell.m
//  podsGolvon
//
//  Created by SHL on 2016/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublicBenefitTableViewCell.h"

@implementation PublicBenefitTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    _rankLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), kHvertical(18), kHvertical(19), kHvertical(19)) textColor:BlackColor fontSize:kHorizontal(12) Title:@"1"];
    _rankLabel.backgroundColor = ClearColor;
    _rankLabel.layer.masksToBounds = YES;
    _rankLabel.layer.cornerRadius = kHvertical(9.5);
    [_rankLabel setTextAlignment:NSTextAlignmentCenter];
    
    _headerView = [Factory createImageViewWithFrame:CGRectMake(_rankLabel.x_width + kWvertical(10), kHvertical(7.5), kHvertical(40), kHvertical(40)) Image:[UIImage imageNamed:@""]];
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = kHvertical(20);
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.frame = CGRectMake(_headerView.x_width-kWvertical(13), _headerView.y_height-kWvertical(13), kWvertical(13), kWvertical(13));
    _Vimage.hidden = YES;
    
    
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(_headerView.x_width + kWvertical(13), 0, ScreenWidth/2, kHvertical(55)) textColor:rgba(43,43,43,1) fontSize:kHorizontal(14) Title:@"暗物质"];
    
    _moneyLabel = [Factory createLabelWithFrame:CGRectMake(ScreenWidth/2 , 0, ScreenWidth/2 - kWvertical(20), kHvertical(55)) textColor:rgba(32,32,32,1) fontSize:kHorizontal(14) Title:@"元"];
    [_moneyLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:_rankLabel];
    [self.contentView addSubview:_headerView];
    [self.contentView addSubview:_Vimage];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_moneyLabel];
    
}

-(void)configModel:(PublicBenefitModel *)model{
    _rankLabel.textColor = rgba(42,42,42,1);
    _rankLabel.backgroundColor = ClearColor;

    if ([model.vid isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }

    NSString *rank = model.rank;
    switch ([rank integerValue]) {
        case 1:{
            _rankLabel.textColor = WhiteColor;
            _rankLabel.backgroundColor = rgba(245,206,35,1);
        }break;
            
        case 2:{
            _rankLabel.textColor = WhiteColor;
            _rankLabel.backgroundColor = rgba(216,216,216,1);
        }break;
            
        case 3:{
            _rankLabel.textColor = WhiteColor;
            _rankLabel.backgroundColor = rgba(201,170,141,1);
        }break;
            
        default:
            break;
    }
    _rankLabel.text = rank;
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:nil];
    _nameLabel.text = model.nickname;
    
    NSString *charity = model.charity;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",charity];
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
