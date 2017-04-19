//
//  DZ_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "DZ_TableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation DZ_TableViewCell


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
    [_headerBtn addTarget:self action:@selector(clickToHeader) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headerBtn];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameBtn setTitleColor:GPColor(57, 133, 221) forState:UIControlStateNormal];
    [_nameBtn addTarget:self action:@selector(clickToNickName) forControlEvents:UIControlEventTouchUpInside];
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_nameBtn];
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.textColor = GPColor(63, 63, 63);
    _typeLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [self.contentView addSubview:_typeLabel];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = SeparatorColor;
    [self.contentView addSubview:_lineView];
    
    _imageViewO = [[UIImageView alloc] init];
    
    _imageViewO.frame = CGRectMake(kWvertical(66), kHvertical(35), WScale(13.3), WScale(13.3));
    _imageViewO.clipsToBounds = YES;
    _imageViewO.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageViewO];
    
    
    _imageViewT = [[UIImageView alloc] init];
    _imageViewT.frame = CGRectMake(_imageViewO.right + WScale(1.6), kHvertical(35), WScale(13.3), WScale(13.3));
    _imageViewT.clipsToBounds = YES;
    _imageViewT.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageViewT];
    
    
    _imageViewS = [[UIImageView alloc] init];
    _imageViewS.frame = CGRectMake(_imageViewT.right + WScale(1.6), kHvertical(35), WScale(13.3), WScale(13.3));
    _imageViewS.clipsToBounds = YES;
    _imageViewS.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageViewS];
    
}
-(void)realyoutWithModel:(dianZanModel *)model{
    self.model = model;
    
    [_headerBtn sd_setImageWithURL:[NSURL URLWithString:model.avator] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    _Vimage.frame = CGRectMake(_headerBtn.right - kWvertical(12), kHvertical(40), kWvertical(12), kWvertical(12));
    if ([model.cuvid isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
    UILabel *nameTest = [[UILabel alloc]init];
    nameTest.frame = CGRectMake(0, 0, 200, 20);
    nameTest.text = model.nickname;
    nameTest.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [nameTest sizeToFit];
    [_nameBtn setTitle:nameTest.text forState:UIControlStateNormal];
    _nameBtn.frame = CGRectMake(kWvertical(66), kHvertical(12), nameTest.width, kHvertical(20));

    
    //    点赞类型 + 内容
    if ([model.type isEqualToString:@"1"]) {
        
        _typeLabel.text = @"赞了你的专访";
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.vtitle];
        
        
    }else if ([model.type isEqualToString:@"3"]){
        
        _typeLabel.text = @"赞了你的榜单";
        _titleLabel.text = [NSString stringWithFormat:@"%@",@""];
        
    }else if ([model.type isEqualToString:@"4"]){
        _typeLabel.text = @"赞了你的动态";
        
        if ([model.hascontent isEqualToString:@"1"]) {
            
            _titleLabel.text = [NSString stringWithFormat:@"%@",model.dcontent];
         
        }else{
            if (model.pics.count == 1) {
                
                [_imageViewO sd_setImageWithURL:[NSURL URLWithString:model.pics[0].url]];
            }else if (model.pics.count == 2){
                
                [_imageViewO sd_setImageWithURL:[NSURL URLWithString:model.pics[0].url]];
                [_imageViewT sd_setImageWithURL:[NSURL URLWithString:model.pics[1].url]];
            }else{
                
                [_imageViewO sd_setImageWithURL:[NSURL URLWithString:model.pics[0].url]];
                [_imageViewT sd_setImageWithURL:[NSURL URLWithString:model.pics[1].url]];
                [_imageViewS sd_setImageWithURL:[NSURL URLWithString:model.pics[2].url]];
            }
        }
        
    }
//    点赞类型
    _typeLabel.frame = CGRectMake(_nameBtn.right + kWvertical(12), kHvertical(14), 200, kHvertical(18));
    [_typeLabel sizeToFit];
    
//    点赞内容
    CGSize titleSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(kWvertical(303), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(12)]} context:nil].size;
    
    _titleLabel.frame = CGRectMake(kWvertical(66), kHvertical(35), kWvertical(303), titleSize.height);

    
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

-(void)clickToHeader{
    if (self.ClickHeaderBlock) {
        self.ClickHeaderBlock(self.model);
    }
}
-(void)clickToNickName{
    if (self.ClickNickNameBlock) {
        self.ClickNickNameBlock(self.model);
    }
}
@end
