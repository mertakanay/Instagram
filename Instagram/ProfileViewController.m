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

@property User *currentUser;
@property NSArray *followingArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

}

-(void)viewWillAppear:(BOOL)animated
{
    PFRelation *relation = [User currentUser].followings;
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.followingArray = objects;

        self.followingsLabel.text = [NSString stringWithFormat:@"%lu following",self.followingArray.count];
        self.fullNameLabel.text = [self.currentUser objectForKey:@"name"];
        [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.profileImageView.image = image;
            }
        }];

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
