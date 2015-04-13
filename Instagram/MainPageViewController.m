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
@property NSArray *imagesObjectsArray;
@property (strong, nonatomic) Image *imageObject;
@property (nonatomic) UITapGestureRecognizer *tapGestureOnPhoto;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ImageObject = [Image new];
    
    //set the gesture recognizer
    [self setRequiredTappedGestureRecognizers];
    
    //add gesture recognizer to the view.
//    [self.view addGestureRecognizer:self.tapGestureRecognizer];
//    self.tapGestureOnPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOnTextView:)];
//    self.tapGestureOnPhoto.numberOfTapsRequired = 1;
//



}
-(void)viewWillAppear:(BOOL)animated{
    self.imagesObjectsArray = [NSArray new];
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
    
    
    NSInteger index0 = indexPath.row;
    NSLog(@"Test:index0    %li\n",index0);
    NSLog(@"Test:    %@\n",((Image *)self.imagesObjectsArray[index0]).username);

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
   // cell.imageInfoText.text = @"Hi";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.imageInfoText.tag = indexPath.row;
    cell.feedImage.tag = indexPath.row;
    cell.imageOwnerProfilePicture.tag = indexPath.row;
    cell.imageOwnerUsername.tag = indexPath.row;
    

    UITapGestureRecognizer  *tapGestureOnPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOnTextView:)];
    tapGestureOnPhoto.numberOfTapsRequired = 1;

    cell.imageInfoText.userInteractionEnabled = YES;
    [cell.imageInfoText addGestureRecognizer:tapGestureOnPhoto];
    
    self.imageObject = self.imagesObjectsArray[indexPath.row];
    
  
  //image text
    cell.imageInfoText.text = [NSString stringWithFormat:@"43 Likes \n%@ %@",self.imageObject.username, self.imageObject.imageDescription];
    NSRange range = [cell.imageInfoText.text rangeOfString:self.imageObject.username];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:cell.imageInfoText.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25.0f]} range:range];
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
    
    NSLog(@"cell %li is ready",indexPath.row);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.imagesObjectsArray.count;
}





- (IBAction)logOutButtonTapped:(UIBarButtonItem *)sender {
    [PFUser logOut];


    
}

-(void)handleTapOnTextView:(UITapGestureRecognizer *)sender
{
    NSLog(@"tapped photo tag: %li", sender.view.tag);
//    CGPoint tapLocation = [sender locationInView:sender.view];
//    CGRect linkPosition = [self frameOfTextRange:result.range inTextView:sender.view];
    UITextView *textView = (UITextView *)(sender.view);
    NSUInteger indexOfTappedCharacter = [self indexOfTappedCharacterInTextView:textView withTapGesture:sender];
    NSRange range = [textView.text rangeOfString:((Image *)self.imagesObjectsArray[textView.tag]).username];
    if (indexOfTappedCharacter >= range.location &&
        indexOfTappedCharacter < range.location + range.length) {
        [self performSegueWithIdentifier:@"MainToDetailSegue" sender:sender];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainToDetailSegue"]) {
        DetailPictureViewController *detailVC = segue.destinationViewController;
       
        NSInteger index = ((UIGestureRecognizer *)sender).view.tag;
        NSLog(@"Test:    %li\n",index);
        NSLog(@"Test:    %@\n",((Image *)self.imagesObjectsArray[index]).username);
        
        detailVC.photo = self.imagesObjectsArray[index];
    }
}


- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect firstRect = [textView firstRectForRange:textRange];
    CGRect newRect = [textView convertRect:firstRect fromView:textView.textInputView];
    return newRect;
}

-(NSUInteger)indexOfTappedCharacterInTextView:(UITextView *)textView withTapGesture:(UITapGestureRecognizer *)tapGesture
{
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [tapGesture locationInView:textView];
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    return characterIndex;
}


@end
