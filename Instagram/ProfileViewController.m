//
//  ProfileViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *followingsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    self.followingsLabel.text = [NSString stringWithFormat:@"%lu following",(unsigned long)self.currentUser.followingArray.count];
    self.fullNameLabel.text = self.currentUser.fullName;
    NSLog(@"%@",self.currentUser.fullName);
        [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.profileImageView.image = image;
            }
        }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditProfileViewController *editVC = [segue destinationViewController];
    editVC.currentUser = self.currentUser;
}

@end
