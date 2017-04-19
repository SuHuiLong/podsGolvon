//
//  ActivityTableViewCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell ()

@end
@implementation ActivityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

-(void)createCell{
    _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(21), 0, kWvertical(80), kHvertical(38))];
    _describeLabel.textColor = deepColor;
    _describeLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_describeLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(250)-kWvertical(21), 0,kWvertical(250) ,kHvertical(38))];
    _contentLabel.textColor = textTintColor;
    _contentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    
}
@end
