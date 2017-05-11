//
//  RoomDetailCircleBottomView.h
//  LuNengHotel
//
//  Created by 拓之林 on 16/4/7.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkImageCircleBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageIndexLabel;
+ (id)loadFromXib;
@end
