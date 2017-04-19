//
//  LeftJobtableView.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LeftJobtableView.h"
#import "LeftMode.h"
@implementation LeftJobtableView


- (void)reloadWithMode:(LeftMode*)mode{

// _leftLabel.frame = CGRectMake(10, 10, 200, 40);
    _leftLabel.text = [NSString stringWithFormat:@"%@",mode.work_content];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    [self creatCell];

    return self;
}


- (void)creatCell{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(7.5)-0.5, WScale(50), 0.5)];
    lineView.backgroundColor = GPColor(212, 213, 214);
    [self.contentView addSubview:lineView];
    
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(2.2), ScreenWidth/2, HScale(3.1))];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_leftLabel];
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake( ScreenWidth/2-1,0, 1, HScale(7.5))];
    _leftView.backgroundColor = GPColor(212, 213, 214);
    [self.contentView addSubview:_leftView];

}
@end
