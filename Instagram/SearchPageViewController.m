//
//  SearchPageViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/8/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SearchPageViewController.h"
#import "User.h"
#import "SearchTableCell.h"

@interface SearchPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *usersArray;
@property NSMutableArray *followingArray;
//@property User *currentUser;
//@property SearchTableCell *aCell;

@end

@implementation SearchPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFRelation *relation = [User currentUser].followings;
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.followingArray = objects.mutableCopy;

//        self.currentUser = [User currentUser];

        NSArray *emptyArray = @[];
        PFQuery *newQuery=[User query];
        [newQuery whereKey:@"username" notContainedIn:emptyArray];
        [newQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            self.usersArray = users;
            [self.tableView reloadData];

        }];

    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIDS"];

    cell.followButton.tag = indexPath.row;

    User *aSelectedUser = [self.usersArray objectAtIndex:indexPath.row];

    if ([self areWeFollowingUser:aSelectedUser])
    {
        [cell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        cell.followButton.tintColor = [UIColor redColor];

    }else {
        [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        cell.followButton.tintColor = [UIColor blueColor];

    }

    cell.textLabel.text = [[self.usersArray objectAtIndex:indexPath.row]username];

    //CODE FOR CELLS TO SHOW IMAGE

    //    [[[self.recommendationArray objectAtIndex:indexPath.row]profileImage] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    //        if (!error) {
    //            UIImage *image = [UIImage imageWithData:data];
    //            cell.imageView.image = image;
    //        }
    //    }];


    [cell.followButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    

    return cell;
}

-(BOOL)areWeFollowingUser:(User *)user
{

    for (User *aUser in self.followingArray)
    {
        if ([aUser.objectId isEqualToString:user.objectId]) {
            return true;
        }
    }
    return false;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

-(void)followButtonPressed:(UIButton *)sender{

    User *selectedUser = [self.usersArray objectAtIndex:sender.tag];

    if (![self areWeFollowingUser:selectedUser])
    {
        [[User currentUser].followings addObject:selectedUser];
        [self.followingArray addObject:selectedUser];
        //        [self.currentUser.followingArray addObject:selectedUser];
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
        sender.tintColor = [UIColor redColor];

    }else if ([self areWeFollowingUser:selectedUser])
    {
        [[User currentUser].followings removeObject:selectedUser];
        [self.followingArray removeObject:selectedUser];
        //        [self.currentUser.followingArray removeObject:selectedUser];
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
        sender.tintColor = [UIColor blueColor];
        
    }
    
}


@end
