//
//  Massage_TableViewCell.m
//  Golvon
//  Created by 李盼盼 on 16/3/21.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Massage_TableViewCell.h"

@implementation Massage_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(4.5), HScale(2.8), ScreenWidth * 0.123, ScreenHeight * 0.069)];
    [self.contentView addSubview:_image];

    _title = [[UILabel alloc]initWithFrame:CGRectMake(WScale(21.3), HScale(4.8), ScreenWidth * 0.5, ScreenHeight * 0.031)];
    [self.contentView addSubview:_title];
    
    _unread = [[UILabel alloc]init];
    _unread.backgroundColor = [UIColor redColor];
    _unread.frame = CGRectMake(WScale(91.7), HScale(4.8), ScreenWidth * 0.045, ScreenHeight * 0.024);
    _unread.hidden = YES;
    [self.contentView addSubview:_unread];
}
-(void)relayoutDataWithImage:(NSString *)imageName AndWithTitle:(NSString *)title AndWithUnread:(NSString *)unread{
    _image.image = [UIImage imageNamed:imageName];
    
    _title.text = title;
    _title.font = [UIFont systemFontOfSize:kHorizontal(15)];
    
    _unread.text = unread;
    _unread.layer.masksToBounds = YES;
    _unread.textAlignment = NSTextAlignmentCenter;
    _unread.textColor = [UIColor whiteColor];
    _unread.layer.cornerRadius = ScreenWidth * 0.045/2;
    _unread.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _unread.adjustsFontSizeToFitWidth = YES;
    _unread.hidden = YES;
    
    if (![unread isEqualToString:@"0"]) {
        NSInteger totle = [unread integerValue];
        if (totle>0) {
            _unread.hidden = NO;
            _unread.backgroundColor = [UIColor redColor];
            self.accessoryType = UITableViewCellAccessoryNone;
        }else{
            _unread.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        _unread.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
}

@end
