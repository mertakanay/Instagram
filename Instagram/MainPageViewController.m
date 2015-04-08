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

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *imagesArray;
@property (strong, nonatomic) Image *ImageObject;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ImageObject = [Image new];





}
-(void)viewWillAppear:(BOOL)animated{
    self.imagesArray = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu images.", (unsigned long)objects.count);

            self.imagesArray = objects;
         
            [self.tableView reloadData];

            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}
-(CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.imageText.text = @"Hi";



    self.ImageObject = self.imagesArray[indexPath.row];


    [self.ImageObject.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error){


            UIImage *cellImage = [UIImage imageWithData:data];


            cell.feedImage.image = cellImage;
        }
    }];



    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

- (IBAction)logOutButtonTapped:(UIBarButtonItem *)sender {
    [PFUser logOut];


    
}



@end
