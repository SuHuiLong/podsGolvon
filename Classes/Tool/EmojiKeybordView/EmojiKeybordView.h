//
//  EmojiKeybordView.h
//  EmojiDemo
//
//  Created by suhuilong on 16/9/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectEmoji)(id);

@interface EmojiKeybordView : UIView


@property(nonatomic,copy)selectEmoji  selectEmoji;

@property(nonatomic,strong)UIButton *sendBtn;

@end
