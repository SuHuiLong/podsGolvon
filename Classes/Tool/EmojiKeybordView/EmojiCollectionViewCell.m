//
//  EmojiCollectionViewCell.m
//  EmojiDemo
//
//  Created by suhuilong on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}


-(void)createView{
    _emojiLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _emojiLabel.hidden = NO;
    _emojiLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_emojiLabel];

    [_deleatView removeFromSuperview];
    
    
    _deleatView = [[UIImageView alloc] init];
    _deleatView.frame = CGRectMake((ScreenWidth/8 - kWvertical(21))/2,(ScreenWidth/8 -  kHvertical(15))/2, kWvertical(21), kHvertical(15));
    _deleatView.hidden = YES;
    [self.contentView addSubview:_deleatView];
    
}

-(void)config:(NSString *)str{

    if ([str isEqualToString:@"EmojiDeleat"]) {
        _deleatView.hidden = NO;
        _emojiLabel.hidden = YES;
        _deleatView.image = [UIImage imageNamed:@"EmojiDeleat"];
    }else{
        _deleatView.hidden = YES;
        _emojiLabel.hidden = NO;
        [_emojiLabel setText:str];

    }
}


@end
