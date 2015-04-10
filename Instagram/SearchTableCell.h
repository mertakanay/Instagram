//
//  SearchTableCell.h
//  Instagram
//
//  Created by Mert Akanay on 4/8/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchUserNameLabel;

@end
