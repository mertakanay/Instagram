//
//  DetailPictureViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "DetailPictureViewController.h"
#import "Comment.h"
#import "User.h"
#import "Image.h"

@interface DetailPictureViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

@property (nonatomic) NSArray *comments;

@end

@implementation DetailPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PFRelation *relation = self.photo.comments;
    PFQuery *commentQuery = [relation query];
    [commentQuery includeKey:@"poster"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.comments = objects;
        [self.commentsTableView reloadData];
    }];
    
    
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:self.photo.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            
            NSLog(@"%@",((User *)object).username);
            PFFile *someFile = ((User *)object).profileImage;
            
            [someFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                UIImage *profileImage = [UIImage imageWithData:data];
                self.userImageView.image = profileImage;
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height / 2;
                self.userImageView.layer.masksToBounds = YES;
                self.userImageView.layer.borderWidth = 2.0;
            }];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    [self.photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (!error){
            
            self.photoImageView.image = [UIImage imageWithData:data];
            self.photoImageView.clipsToBounds = true;
            
        }
    }];
    
    self.userNameLabel.text = self.photo.username;
//    self.photoImageView.image = self.photoImage;
//    self.userImageView.image = self.userProfileImage;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self.comments[indexPath.row];

    cell.textLabel.text = comment.poster.username;
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
    cell.textLabel.font  = myFont;
    
    cell.detailTextLabel.text = comment.commentText;
    cell.detailTextLabel.font = myFont;

    return cell;
}

@end
