//
//  CustomTableViewCell.m
//  EBoxPro
//
//  Created by yxj on 5/30/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize theLabel = _theLabel;
@synthesize leftImage = _leftImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 10, 300, 30)];
        self.leftImage = [[UIImageView alloc] init];
        self.theLabel.textColor = [UIColor blackColor];
        self.leftImage.image = [UIImage imageNamed:@"local-50.png"];
//        self.leftImage.height = 10;
        self.leftImage.frame = CGRectMake(0, 1, 50, 50);
        [self.contentView addSubview:self.theLabel];
        [self.contentView addSubview:self.leftImage];
    }
    return self;
}
@end
