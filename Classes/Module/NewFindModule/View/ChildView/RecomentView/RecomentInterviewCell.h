//
//  RecomentInterviewCell.h
//  podsGolvon
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecomInteModel.h"

typedef void (^BtnBlock)(NSInteger tag);

@interface RecomentInterviewCell : UITableViewCell
@property (nonatomic, strong) UILabel   *typeLabel;
@property (nonatomic, strong) BtnBlock   block;
-(void)setBlock:(BtnBlock)block;
-(void)relayoutDataWithArr:(NSMutableArray *)modelArr;
@end
