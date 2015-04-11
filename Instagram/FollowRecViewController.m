//
//  FollowRecViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "FollowRecViewController.h"
#import "FollowRecCell.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FollowRecViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *recommendationArray;
@property (nonatomic) NSMutableArray *selectedUsers;

@end

@implementation FollowRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedUsers = [NSMutableArray new];
//    self.currentUser.followingArray = [NSMutableArray new];
//    self.currentUser = [User currentUser];

    NSArray *emptyArray = @[];
    

    PFQuery *newQuery=[User query];
    [newQuery whereKey:@"username" notContainedIn:emptyArray];
    [newQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        
        NSLog(@"%li",(unsigned long)users.count);
        self.recommendationArray = users;
        [self.tableView reloadData];
        
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowRecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    cell.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];

    cell.followButton.layer.borderWidth=1.0f;
    cell.followButton.layer.borderColor=[[UIColor blackColor] CGColor];
    cell.followButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];

    cell.followRecUsernameLabel.text = [[self.recommendationArray objectAtIndex:indexPath.row]username];

//CODE FOR CELLS TO SHOW IMAGE

    [[[self.recommendationArray objectAtIndex:indexPath.row]profileImage] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.followRecImageView.image = image;
            cell.followRecImageView.layer.cornerRadius = cell.followRecImageView.frame.size.height / 2;
            cell.followRecImageView.layer.masksToBounds = YES;
            cell.followRecImageView.layer.borderWidth = 1.5;
            cell.followRecImageView.clipsToBounds = YES;
            [cell layoutSubviews];
        }
    }];

    cell.followButton.tag = indexPath.row;
    [cell.followButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommendationArray.count;
}

-(void)followButtonPressed:(UIButton *)sender{

    User *selectedUser = [self.recommendationArray objectAtIndex:sender.tag];

    if (![self.selectedUsers containsObject:selectedUser])
    {
//        [[User currentUser] addUniqueObject:selectedUser forKey:@"followingArray"];
        [[User currentUser].followings addObject:selectedUser];
        [self.selectedUsers addObject:selectedUser];
//        [self.currentUser.followingArray addObject:selectedUser];
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
        sender.tintColor = [UIColor redColor];
        [[User currentUser] saveInBackground];
   
    }else if ([self.selectedUsers containsObject:selectedUser])
    {
//        [[User currentUser] removeObject:selectedUser forKey:@"followingArray"];
        [[User currentUser].followings removeObject:selectedUser];
        [self.selectedUsers removeObject:selectedUser];
//        [self.currentUser.followingArray removeObject:selectedUser];
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
        sender.tintColor = [UIColor blueColor];
        [[User currentUser] saveInBackground];
    }
}




//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    ProfileViewController *profileVC = [segue destinationViewController];
////    profileVC.currentUser = self.currentUser;
//}


@end
