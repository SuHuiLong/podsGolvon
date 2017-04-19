//
//  LPPeriscommentCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LPPeriscommentCell.h"

@interface LPPeriscommentCell ()


@property (nonatomic, strong) LPPeriscommentMark *mark;
@property (nonatomic, strong) LPPeriscommentLabel *commentLabel;
@property (nonatomic, strong) LPPeriscommentConfig *config;
@property (nonatomic, strong) UILabel *nameLabel;




@end

@implementation LPPeriscommentCell

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment profileImage:(UIImage *)profileImage {
    LPPeriscommentConfig *config = [[LPPeriscommentConfig alloc] init];
    return [self initWithFrame:frame name:name comment:comment profileImage:profileImage config:config];
}

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment profileImage:(UIImage *)profileImage config:(LPPeriscommentConfig *)config {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GPColor(0, 0, 0);
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        self.alpha = 0.7;
        
        self.config = config;
        self.nameLabel.text = name;
        self.commentLabel.text = comment;
        [self.nameLabel sizeToFit];
        [self.commentLabel sizeToFit];
        
//        [self addSubview:self.nameLabel];
        [self addSubview:self.commentLabel];
        
        [self resetFrame:profileImage];
        
        [self addSubview:self.mark];
        
    }
    return self;
}

- (void)resetFrame:(UIImage *)image {
    
    LPPeriscommentConfig *config = self.config;
    CGFloat commentWidth = self.commentLabel.frame.size.width;
    //MAX(self.nameLabel.frame.size.width, self.commentLabel.frame.size.width);
    
    
    CGFloat inferedWidth = config.layout.markWidth + config.layout.offset + commentWidth + config.layout.padding;
    CGFloat width = MIN(inferedWidth, config.layout.maximumWidth);
    
    CGFloat height = config.layout.padding  + config.layout.commentSpace + self.nameLabel.frame.size.height + self.commentLabel.frame.size.height;
    
    //config.layout.padding  + config.layout.commentSpace + self.nameLabel.frame.size.height + self.commentLabel.frame.size.height;
    if (height>HScale(9.0)) {
        height = HScale(9.0);
    }
    if (width>WScale(51.2)) {
        width = WScale(51.2);
    }
    
    
    // cell frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    
    
    
    // mark frame
//    CGSize markSize = CGSizeMake(config.layout.markWidth, height);
    CGRect markRect = CGRectMake(0, 0, 0, 0);
//    CGRect markRect = CGRectMake(0, 0, markSize.width, 30);

    self.mark = [[LPPeriscommentMark alloc] initWithFrame:markRect image:image];
    
    // comment frame
    CGRect commentOriginframe = self.commentLabel.frame;

    self.commentLabel.frame = commentOriginframe;
    
    
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        LPPeriscommentConfig *config = self.config;
        CGPoint namePoint = CGPointMake(config.layout.markWidth + config.layout.offset, config.layout.padding);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(namePoint.x, namePoint.y, 0, 0)];
        nameLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        //config.nameFont.font;
        nameLabel.textColor = config.nameFont.color;
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (LPPeriscommentLabel *)commentLabel {
    if (!_commentLabel) {
        LPPeriscommentConfig *config = self.config;
        CGFloat commentMaxWidth = [config.layout prepareCommentMaxWidth];

        

        

        
        if (commentMaxWidth>WScale(40)) {
            commentMaxWidth = WScale(40);
        }
        
        LPPeriscommentLabel *commentLabel = [[LPPeriscommentLabel alloc] initWithFrame:CGRectMake(WScale(9.6), HScale(0.9), 0, 200) font:config.commentFont allowLineBreak:config.layout.allowLineBreak maxWidth:WScale(40)];
        
        
        commentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        commentLabel.numberOfLines = 3;
        commentLabel.textColor = [UIColor whiteColor];
        _commentLabel = commentLabel;
    }
    return _commentLabel;
}

@end



@implementation LPPeriscommentLabel

- (instancetype)initWithFrame:(CGRect)frame font:(LPTPeriscommentFont *)commentfont allowLineBreak:(BOOL)allow maxWidth:(CGFloat)maxWidth {
    if (self = [super initWithFrame:frame]) {
        _allowLineBreak = allow;
        _maxCommentWidth = maxWidth;
        self.textColor = commentfont.color;
        self.font = commentfont.font;
    }
    return self;
}

- (void)sizeToFit {
    if (self.allowLineBreak) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
//        self.numberOfLines = 0;
    }
    [super sizeToFit];
    [self resetSize];
    [super sizeToFit];
}

- (void)resetSize {
    CGFloat width = MIN(self.maxCommentWidth, self.frame.size.width);
    CGRect originFrame = self.frame;
    originFrame.size.width = width;
    self.frame = originFrame;
}




@end
