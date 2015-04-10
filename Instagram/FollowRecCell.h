//
//  FollowRecCell.h
//  Instagram
//
//  Created by Mert Akanay on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowRecCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followRecUsernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *followRecImageView;

@end
