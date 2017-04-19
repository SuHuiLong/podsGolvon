//
//  LPPeriscommentView.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPeriscommentView : UIView

- (void)addCellWithName:(NSString *)name
                comment:(NSString *)comment
           profileImage:(UIImage *)profileImage;

@end

NS_ASSUME_NONNULL_END