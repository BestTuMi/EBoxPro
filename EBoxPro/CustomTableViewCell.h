//
//  CustomTableViewCell.h
//  EBoxPro
//
//  Created by yxj on 5/30/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CustomTableViewCell : SWTableViewCell

@property (strong,nonatomic)UIImageView *leftImage;
@property (strong,nonatomic)UILabel *theLabel;

@end
