//
//  rightJobTableView.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "rightJobTableView.h"
#import "Rightmode.h"
@implementation rightJobTableView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _Rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(2.2), WScale(50), HScale(2.7))];
    _Rightlabel.textColor = GPColor(62, 66, 77);
    _Rightlabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _Rightlabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_Rightlabel];
    
}
-(void)relayoutAndModel:(Rightmode *)model{
    
    _Rightlabel.text = [NSString stringWithFormat:@"%@",model.work_content];
}
@end
