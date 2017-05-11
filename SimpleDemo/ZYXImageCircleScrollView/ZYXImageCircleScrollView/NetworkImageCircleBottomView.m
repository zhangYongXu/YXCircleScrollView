//
//  RoomDetailCircleBottomView.m
//  LuNengHotel
//
//  Created by 拓之林 on 16/4/7.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "NetworkImageCircleBottomView.h"
@interface NetworkImageCircleBottomView()


@end
@implementation NetworkImageCircleBottomView
-(void)awakeFromNib{
    [super awakeFromNib];
}
+ (id)loadFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

@end
