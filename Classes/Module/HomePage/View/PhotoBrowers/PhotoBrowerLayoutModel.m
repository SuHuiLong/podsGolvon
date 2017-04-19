//
//  PhotoBrowerLayoutModel.m
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoBrowerLayoutModel.h"

#define KDEFAULTINSET 2; //间隙
#define KContentWidth (_contentWidth?:[UIScreen mainScreen].bounds.size.width)

// 1张大图的高度
#define kBigImageHeight kImageWH(3)*2+kContentSpace
// 2张小图的宽高
#define kTwoSmallImageWH kImageWH(2)
// 3张小图的宽高
#define kThreeSmallImageWH kImageWH(3)
// 4张小图的宽高
#define kfourSmallImageWH kImageWH(4)

#define kImageWH(nums) (KContentWidth-kLeftSpace-kContentSpace*(nums-1)-kRightSpace)/nums

#define kContentSpace (_contentInset?:0)
#define kTopSpace (_topInset?:0)
#define kLeftSpace (_leftInset?:0)
#define kBottonSpace (_bottomInset?:0)
#define kRightSpace (_rightInset?:0)

@interface PhotoBrowerLayoutModel ()

@property (nonatomic, assign) NSInteger imageNums; // 图片数量

@end

@implementation PhotoBrowerLayoutModel

-(instancetype)initWithPhotoUrlsArray:(NSArray *)photoUrlsArray andOrigin:(CGPoint)origin{
    if (self = [super init]) {
        
        _origin = origin;
        _photoUrlsArray = photoUrlsArray;
        _contentWidth = KContentWidth;
        _contentInset = KDEFAULTINSET;
        _topInset = KDEFAULTINSET;
        _leftInset = KDEFAULTINSET;
        _bottomInset = KDEFAULTINSET;
        _rightInset = KDEFAULTINSET;
        self.imageNums = photoUrlsArray.count;
    }
    
    return self;
}

- (instancetype)initWithPhotoUrlsArray:(NSArray *)photoUrlsArray ContentWidth:(CGFloat)contentWidth andEdgeInsets:(UIEdgeInsets)edgeInsets andContentInset:(CGFloat)contentInset andOrigin:(CGPoint)origin
{
    if (self = [super init]) {
        _origin = origin;
        _photoUrlsArray = photoUrlsArray;
        _contentWidth = contentWidth;
        _contentInset = contentInset;
        _topInset = edgeInsets.top;
        _leftInset = edgeInsets.left;
        _bottomInset = edgeInsets.bottom;
        _rightInset = edgeInsets.right;
        self.imageNums = photoUrlsArray.count;
    }
    
    return self;
    
}

- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0;
    
    if (self.imageNums==0) {
        contentHeight = 0;
    } else if (self.imageNums==1) {
        contentHeight = kTopSpace+(kBigImageHeight+kContentSpace)*(self.imageNums-1)+kBigImageHeight+kBottonSpace;
    }else if (self.imageNums==2){
        contentHeight = kTopSpace+kContentSpace+kTwoSmallImageWH+kBottonSpace;
    }else if (self.imageNums==3) {
        contentHeight = kTopSpace+kContentSpace+kTwoSmallImageWH+kBigImageHeight+kBottonSpace;
    } else if (self.imageNums==4) {
        contentHeight = kTopSpace+kContentSpace+kBigImageHeight+kThreeSmallImageWH+kBottonSpace;
    } else if (self.imageNums==5) {
        contentHeight = kContentSpace+kTopSpace+kBigImageHeight+kTwoSmallImageWH+kBottonSpace;
    } else if (self.imageNums==6) {
        contentHeight = kContentSpace+kTopSpace+kBigImageHeight+kThreeSmallImageWH+kBottonSpace;
    }
    return contentHeight;
}
//图片样式
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath andNumberOfCellsInSection:(NSInteger)numberOfCellsInSection
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    /*
     图片样式
     1：一张大图
     2：上一张图，下一张图
     3：上一张大图，下两张小图
     4：上一张大图，下三张小图
     5：上左一张大图，上右 上下 两张小图 ，下两张小图
     6：上左一张大图，上右 上下 两张小图 ，下三张小图
     */
    switch (numberOfCellsInSection) {
        case 0:break;
        case 1:
        {
            
            attribute.frame = CGRectMake(kLeftSpace, kTopSpace+(kBigImageHeight+kContentSpace)*indexPath.item, KContentWidth-kLeftSpace-kTopSpace, kBigImageHeight);
        }
            break;
        
        case 2:
        {
            attribute.frame = CGRectMake(kLeftSpace+(kContentSpace+kTwoSmallImageWH)*(indexPath.item), kTopSpace, kTwoSmallImageWH, kTwoSmallImageWH);
        }
            break;
        case 3:
        {
            if (indexPath.item==0) {
                attribute.frame = CGRectMake(kLeftSpace, kTopSpace, KContentWidth-kLeftSpace-kRightSpace, kBigImageHeight);
            } else{
                attribute.frame = CGRectMake(kLeftSpace+(kContentSpace+kTwoSmallImageWH)*(indexPath.item-1), kTopSpace+(kContentSpace+kBigImageHeight), kTwoSmallImageWH, kTwoSmallImageWH);
            }
        }
            break;
        case 4:
        {
            if (indexPath.item==0) {
                attribute.frame = CGRectMake(kLeftSpace, kTopSpace, KContentWidth-kLeftSpace-kRightSpace, kBigImageHeight);
            } else {
                attribute.frame = CGRectMake(kLeftSpace+(kContentSpace+kThreeSmallImageWH)*(indexPath.item-1), kTopSpace+kContentSpace+kBigImageHeight, kThreeSmallImageWH, kThreeSmallImageWH);
            }
        }
            break;
        case 5:
        {
            if (indexPath.item==0) {
                attribute.frame = CGRectMake(kLeftSpace, kTopSpace, kBigImageHeight, kBigImageHeight);
            } else if (indexPath.item==1 || indexPath.item==2) {
                attribute.frame = CGRectMake(kLeftSpace+kBigImageHeight+kContentSpace, kTopSpace+(kContentSpace+kThreeSmallImageWH)*(indexPath.item-1), kThreeSmallImageWH,kThreeSmallImageWH);
            } else {
                attribute.frame = CGRectMake(kLeftSpace+(kContentSpace+kTwoSmallImageWH)*(indexPath.item-3), kContentSpace+kTopSpace+kBigImageHeight, kTwoSmallImageWH, kTwoSmallImageWH);
            }
        }
            break;
            
        case 6:
        {
            if (indexPath.item==0) {
                attribute.frame = CGRectMake(kLeftSpace, kTopSpace, kBigImageHeight, kBigImageHeight);
            } else if (indexPath.item==1 || indexPath.item==2) {
                attribute.frame = CGRectMake(kLeftSpace+kBigImageHeight+kContentSpace, kTopSpace+(kContentSpace+kThreeSmallImageWH)*(indexPath.item-1), kThreeSmallImageWH,kThreeSmallImageWH);
            }else {
                attribute.frame = CGRectMake(kLeftSpace+(kContentSpace+kThreeSmallImageWH)*(indexPath.item-3), kContentSpace+kTopSpace+kBigImageHeight, kThreeSmallImageWH, kThreeSmallImageWH);
            }
        }
            
            break;
        default:
            break;
    }
    
    
    return attribute;
}


@end
