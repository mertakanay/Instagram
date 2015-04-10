//
//  MainPageViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "MainPageViewController.h"
#import <Parse/Parse.h>
#import "CustomTableViewCell.h"
#import "Image.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *imagesObjectsArray;
@property (strong, nonatomic) Image *imageObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOutButton;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageObject = [Image new];




}
-(void)viewWillAppear:(BOOL)animated{
    self.imagesObjectsArray = [NSMutableArray new];
    NSMutableArray *listOfUser = [NSMutableArray new];

    User *currentUser = [User currentUser];
    PFRelation *followings = currentUser.followings;
    [[followings query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (User *user in objects) {
            NSLog(@"%@",user.username);


            [listOfUser addObject:user.username];

        }
        PFQuery *query = [Image query];
        [query whereKey:@"username" containedIn:listOfUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu images.", (unsigned long)objects.count);

                self.imagesObjectsArray = objects;



                [self.tableView reloadData];


            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }];




}

//On Double Tap - the user is able to like the picture. The heart overlaying the the image appears when the user taps on the image.
- (void)doubleTapGestureCaptured:(UITapGestureRecognizer*)gesture{
    NSLog(@"Left Image clicked");

    UIImageView *imageV = (UIImageView *)gesture.view;
    NSInteger row = imageV.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    [UIView animateWithDuration:(.5) animations:^{
        cell.heartImage.alpha = 1.0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{

            cell.heartImage.alpha = 0.0;
        }];
    }];






}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma marks - UITableView Delegate Methods


-(CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    // cell.imageInfoText.text = @"Hi";



    self.imageObject = self.imagesObjectsArray[indexPath.row];


    //image text
    cell.imageInfoText.text = [NSString stringWithFormat:@"43 Likes \n%@ %@",self.imageObject.username, self.imageObject.imageDescription];
    NSRange range = [cell.imageInfoText.text rangeOfString:self.imageObject.username];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:cell.imageInfoText.text];


    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]} range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    [cell.imageInfoText  setAttributedText:attributedText];

    cell.imageInfoText.attributedText = attributedText;

    //image owner name
    cell.imageOwnerUsername.text = self.imageObject.username;


    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:self.imageObject.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {


            PFFile *someFile = ((User *)object).profileImage;

            [someFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {



                UIImage *profileImage = [UIImage imageWithData:data];
                cell.imageOwnerProfilePicture.image = profileImage;
                cell.imageOwnerProfilePicture.layer.cornerRadius = cell.imageOwnerProfilePicture.frame.size.height / 2;
                cell.imageOwnerProfilePicture.layer.masksToBounds = YES;
                cell.imageOwnerProfilePicture.layer.borderWidth = 2.0;


            }];



        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];



    [self.imageObject.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error){


            UIImage *cellImage = [UIImage imageWithData:data];
            //UIImage *userImage = [UIImage imagewithdata]


            cell.feedImage.image = cellImage;
            //cell.imageOwnerProfilePicture =
            cell.feedImage.clipsToBounds = true;

        }
    }];

    cell.feedImage.userInteractionEnabled = YES;
    cell.feedImage.tag = indexPath.row;

    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCaptured:)];
    tapped.numberOfTapsRequired = 2;
    [cell.feedImage addGestureRecognizer:tapped];

    //set the tag image.
    cell.feedImage.tag = indexPath.row;
    
    
    
    
    
    
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imagesObjectsArray.count;
}

- (IBAction)logOutButtonTapped:(UIBarButtonItem *)sender {
    [PFUser logOut];
    
}



@end
