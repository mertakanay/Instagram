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
    
    PFQuery *query = [Image query];
    [query includeKey:@"comments"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.comments = objects;
        [self.commentsTableView reloadData];
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", comment.poster.username,
                           comment.commentText];
    return cell;
}

@end
