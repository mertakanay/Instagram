//
//  ProfileViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "Image.h"
#import "ProfileCollectionViewCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *followingsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFollowersLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

@property User *currentUser;
@property NSArray *followingArray;
@property NSArray *imagesArray;
@property Image *imageObject;
@property NSArray *followersArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    self.view.backgroundColor =[UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];
    self.editProfileButton.layer.borderWidth=1.5f;
    self.editProfileButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.editProfileButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];


}

-(void)viewWillAppear:(BOOL)animated
{
    PFRelation *relation = [User currentUser].followings;
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.followingArray = objects;

        self.followingsLabel.text = [NSString stringWithFormat:@"%i following",self.followingArray.count];
        self.fullNameLabel.text = [self.currentUser objectForKey:@"name"];
        [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.profileImageView.image = image;
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                self.profileImageView.layer.masksToBounds = YES;
                self.profileImageView.layer.borderWidth = 1.5;
            }
        }];

        PFQuery *query = [Image query];
        [query whereKey:@"username" equalTo:self.currentUser.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.imagesArray = objects;
                self.numberOfPostsLabel.text = [NSString stringWithFormat:@"%i posts",self.imagesArray.count];
                [self.collectionView reloadData];
            }
        }];

    }];

//finding followings

        PFQuery *secondQuery=[User query];
        [secondQuery whereKey:@"followings" equalTo:self.currentUser];
        [secondQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            self.followersArray = users;
            self.numberOfFollowersLabel.text = [NSString stringWithFormat:@"%i followers",self.followersArray.count];
        }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];

    self.imageObject = self.imagesArray[indexPath.row];

    [self.imageObject.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error){

            UIImage *cellImage = [UIImage imageWithData:data];

            cell.cellImageView.image = cellImage;
            cell.cellImageView.clipsToBounds = true;
            
        }
    }];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditProfileViewController *editVC = [segue destinationViewController];
    editVC.currentUser = self.currentUser;
}

@end
