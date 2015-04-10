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
#import "DetailPictureViewController.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *imagesObjectsArray;
@property (strong, nonatomic) Image *imageObject;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ImageObject = [Image new];
    
    //set the gesture recognizer
    [self setRequiredTappedGestureRecognizers];
    
    //add gesture recognizer to the view.
//    [self.view addGestureRecognizer:self.tapGestureRecognizer];




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
//Helper method to set up the tapped gesture recognizer.
-(void)setRequiredTappedGestureRecognizers{
    //1. set up the number of taps.
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    //2. set the number of fingers required.
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    
}
//Helper method to detect if username of photo owner has been taped.
-(NSString *)tappedResponder:(UITapGestureRecognizer *)recognizer{
    
    //get the textview
    UITextView *textView = (UITextView *)recognizer.view;
    
    //get the location
    CGPoint location = [recognizer locationInView:textView];
    UITextPosition *tappedPosition = [textView closestPositionToPoint:location];
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tappedPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];

    //return text
    return [textView textInRange:textRange];
    
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
        
               // UIImage *profileImage
            //cell.imageOwnerProfilePicture.image = profileImage;

            
            
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



    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imagesObjectsArray.count;
}

- (IBAction)logOutButtonTapped:(UIBarButtonItem *)sender {
    [PFUser logOut];


    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainToDetailSegue"]) {
        DetailPictureViewController *detailVC = segue.destinationViewController;
        
        detailVC.photo = self.imagesObjectsArray[[self.tableView indexPathForSelectedRow].row];
    }
}



@end
