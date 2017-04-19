//
//  HF_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "HF_TableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HF_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
 
    _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerBtn.frame = CGRectMake(kWvertical(14), kHvertical(14), kWvertical(38), kWvertical(38));
    _headerBtn.layer.masksToBounds = YES;
    _headerBtn.layer.cornerRadius = kWvertical(19);
    [_headerBtn addTarget:self action:@selector(clickHeadericon) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headerBtn];
    
    _VimageView = [[UIImageView alloc] init];
    _VimageView.image = [UIImage imageNamed:@"个人中心加v"];
    _VimageView.hidden = YES;
    [self.contentView addSubview:_VimageView];
    
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameBtn setTitleColor:GPColor(57, 133, 221) forState:UIControlStateNormal];
    [_nameBtn addTarget:self action:@selector(clickNameBtn) forControlEvents:UIControlEventTouchUpInside];
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_nameBtn];
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.textColor = GPColor(63, 63, 63);
    _typeLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [self.contentView addSubview:_typeLabel];

    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _formatLabel = [[CustomeLabel alloc]init];
    _formatLabel.backgroundColor = GPColor(240, 239, 241);
    _formatLabel.textColor = GPColor(112, 113, 115);
    _formatLabel.layer.masksToBounds = YES;
    _formatLabel.layer.cornerRadius = 2;
    _formatLabel.numberOfLines = 0;
    _formatLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _formatLabel.textInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    [self.contentView addSubview:_formatLabel];
    
    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
}
-(void)relayoutWithModel:(huiFuModel *)model{

    self.model = model;
//    头像
    [_headerBtn sd_setImageWithURL:[NSURL URLWithString:model.avator] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    _VimageView.frame = CGRectMake(_headerBtn.right - kWvertical(12), kHvertical(40), kWvertical(12), kWvertical(12));
    
    if ([model.cuvid isEqualToString:@"0"]) {
        
        _VimageView.hidden = YES;
        
    }else{
        
        _VimageView.hidden = NO;
    }

//    昵称
    UILabel *nameTest = [[UILabel alloc]init];
    nameTest.frame = CGRectMake(0, 0, 200, 20);
    nameTest.text = model.nickname;
    nameTest.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [nameTest sizeToFit];
    [_nameBtn setTitle:nameTest.text forState:UIControlStateNormal];
    _nameBtn.frame = CGRectMake(kWvertical(66), kHvertical(12), nameTest.width, kHvertical(20));
    
    /** 1为专访评论，2为评论回复，3为朋友圈评论,4为朋友圈回复  * */
    if ([model.type isEqualToString:@"1"]) {
        _typeLabel.text = @"评论了你";
        _formatLabel.hidden = YES;
        _titleLabel.text = model.content;
    }else if ([model.type isEqualToString:@"2"]){
        
        _typeLabel.text = @"回复了你";
        _titleLabel.text = model.content;
        _formatLabel.text = model.orgcontent;
        _formatLabel.hidden = NO;
        
    }else if ([model.type isEqualToString:@"3"]){
        
        _typeLabel.text = @"评论了你";
        _titleLabel.text = model.content;
        _formatLabel.hidden = YES;
        
    }else if ([model.type isEqualToString:@"4"]){
        _typeLabel.text = @"回复了你";
        _titleLabel.text = model.content;
        _formatLabel.text = model.orgcontent;
        _formatLabel.hidden = NO;
    }

    
    
//    内容类型
    _typeLabel.frame = CGRectMake(_nameBtn.right + kWvertical(12), kHvertical(15), 200, kHvertical(18));
    [_typeLabel sizeToFit];
    
   //    内容
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.content];
    CGSize TitleSize= [_titleLabel.text boundingRectWithSize:CGSizeMake(kWvertical(303), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
    _titleLabel.frame = CGRectMake(kWvertical(66), kHvertical(35), kWvertical(303), TitleSize.height);
    
//    自己评论的内容
    _formatLabel.text = [NSString stringWithFormat:@"%@",model.orgcontent];
    CGSize formatSize= [_formatLabel.text boundingRectWithSize:CGSizeMake(kWvertical(330), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(12)]} context:nil].size;
    _formatLabel.frame = CGRectMake(kWvertical(66), _titleLabel.bottom + 8, kWvertical(303), formatSize.height + 12);
    
//    时间
    UILabel *timeTest = [[UILabel alloc]init];
    timeTest.frame = CGRectMake(0, 0, 200, 15);
    timeTest.text = model.time;
    timeTest.font = [UIFont systemFontOfSize:kHorizontal(10)];
    [timeTest sizeToFit];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",timeTest.text];
    _timeLabel.frame = CGRectMake(ScreenWidth - timeTest.width-kWvertical(13), kHvertical(13), timeTest.width, kHvertical(14));
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _timeLabel.textColor = GPColor(135, 135, 135);
    

}

-(void)clickHeadericon{
    if (self.clickHeadericonBlock) {
        self.clickHeadericonBlock(self.model);
    }
}
-(void)clickNameBtn{
    if (self.clickNameBlock) {
        self.clickNameBlock(self.model);
    }
}
@end
