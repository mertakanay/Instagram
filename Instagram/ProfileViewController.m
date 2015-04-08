//
//  ProfileViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *followingsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.followingsLabel.text = [NSString stringWithFormat:@"%lu following",(unsigned long)self.currentUser.followingArray.count];
    self.fullNameLabel.text = self.currentUser.fullName;

        [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.profileImageView.image = image;
            }
        }];
}
@end
