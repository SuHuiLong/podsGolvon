//
//  KeyBoardToolView.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "KeyBoardToolView.h"

@interface KeyBoardToolView ()<UITextViewDelegate>

@end

@implementation KeyBoardToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithTextView];
    }
    return self;
}
- (void)initWithTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(WScale(2.1), (self.frame.size.height - HScale(3.6))/2, self.frame.size.width - WScale(14.3), HScale(3.6))];
    self.textView.layer.cornerRadius = 3;
    self.textView.delegate = self;
    self.textView.layer.masksToBounds = YES;
    self.textView.backgroundColor = RedColor;
//    self.textView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textView];
    
    self.expressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.expressionBtn setImage:[UIImage imageNamed:@"PublishKeybordSmilies"] forState:UIControlStateNormal];
    self.expressionBtn.frame = CGRectMake(ScreenWidth-WScale(3.5)-WScale(8.2), (self.frame.size.height - HScale(3.6))/2, WScale(10), HScale(3.6));
    [self addSubview:self.expressionBtn];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(keyBoardToolShouldEndEditing:)]) {
        [_delegate keyBoardToolShouldEndEditing:textView];
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([_delegate respondsToSelector:@selector(keyBoardTooltextView:shouldChangeTextInRange:replacementText:)]) {
        [_delegate keyBoardTooltextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(keyBoardTooltextViewDidChange:)]) {
        [_delegate keyBoardTooltextViewDidChange:textView];
    }
}

@end
