//
//  SelctMarkViewCollectionViewCell.m
//  Golvon
//
//  Created by shiyingdong on 16/4/27.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SelctMarkViewCollectionViewCell.h"

@implementation SelctMarkViewCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
//        _backView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_backView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(WScale(4), HScale(0.9), self.contentView.width, self.contentView.height)];
        
        [self.contentView addSubview:_textLabel];
        
    }
    
    return self;
}
-(void)shlDataWithModel:(SelectMarkModel *)model{
    
    _textLabel.text = model.markText;
    [_textLabel sizeToFit];
    _backView.frame = CGRectMake(0, 0, _textLabel.frame.size.width+WScale(8), _textLabel.frame.size.height+HScale(1.8));
}

@end
