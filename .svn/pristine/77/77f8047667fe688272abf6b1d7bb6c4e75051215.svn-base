//
//  AddSelfPhotoTableViewCell.m
//  Golvon
//
//  Created by shiyingdong on 16/4/12.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "AddSelfPhotoTableViewCell.h"

@interface AddSelfPhotoTableViewCell()<UITextViewDelegate>

@end

@implementation AddSelfPhotoTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.UserImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.UserImageView];
        
        self.DescLabel = [[UITextView alloc] init];
        self.DescLabel.delegate = self;
        self.DescLabel.backgroundColor = [UIColor whiteColor];
        
        self.PalaceLabel = [UILabel new];
        self.PalaceLabel.hidden = NO;
        self.numberOfTextLength = [[UILabel alloc] init];
        [self.DescLabel addSubview:self.numberOfTextLength];
        [self.DescLabel addSubview:self.PalaceLabel];
        [self.contentView addSubview:self.DescLabel];
        
        
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.UserImageView.frame = CGRectMake(WScale(3.2), HScale(1.8), WScale(32), HScale(18));
    
    self.DescLabel.frame = CGRectMake(WScale(38.4), HScale(1.8), WScale(58.4), HScale(18));
    
    self.PalaceLabel.frame = CGRectMake(6, 2, WScale(57), 40);
    self.PalaceLabel.numberOfLines = 0;
    self.PalaceLabel.textColor = [UIColor colorWithRed:207/255.0 green:208/255.0 blue:209/255.0 alpha:1.0f];
    self.PalaceLabel.font = [UIFont systemFontOfSize:14.f];
    
    self.numberOfTextLength.frame = CGRectMake(0, HScale(56), WScale(58.4), HScale(3));
    self.numberOfTextLength.font = [UIFont systemFontOfSize:14.f];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.DescLabel.text.length];
    int a = 250 - [len intValue];
    if (a==0) {
        self.numberOfTextLength.text = [NSString stringWithFormat:@"评论字数已达上限"];
    }else if (a<0){
        
    }else{
        self.numberOfTextLength.text = [NSString stringWithFormat:@"你还可以输入%d个字",a];
    }
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=250) {
        return NO;
    }else{
        return YES;
    }
}

-(void)textlenth{
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.DescLabel.text.length];
    int a = [len intValue];
    
    self.numberOfTextLength.text = [NSString stringWithFormat:@"你还可以输入%d个字",250-a];
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
