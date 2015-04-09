//
//  CustomTableViewCell.m
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)awakeFromNib{
    [super awakeFromNib];

    self.feedImage.image = nil;
    self.imageOwnerProfilePicture.image = nil;
}

@end
