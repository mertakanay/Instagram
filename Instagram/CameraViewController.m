//
//  CameraViewController.m
//  Instagram
//
//  Created by zhenduo zhu on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraViewController.h"
#import "User.h"
#import "Image.h"
#import "Comment.h"



@interface CameraViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic) UIImagePickerController *cameraImagePickerController;
@property (nonatomic) UIImagePickerController *libraryImagePickerController;

@property (nonatomic) UIImage *albumImage;

@property (nonatomic) Image *pickedPhoto;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self presentCamera];
    
    [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentTextView  layer] setBorderWidth:2.3];
    [[self.commentTextView layer] setCornerRadius:15];
    self.commentTextView.textColor = [UIColor lightGrayColor];
}

-(void)presentCamera
{
    self.cameraImagePickerController = [UIImagePickerController new];
    self.cameraImagePickerController.delegate = self;
    self.cameraImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraImagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.cameraImagePickerController animated:YES completion:nil];
    
    [self getLatestPhotoFromAlbum];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 100, 30)];
    [button setTitle:@"Library" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(gotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraImagePickerController.view addSubview:button];
    
    

}

-(IBAction)gotoLibrary:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker.view setFrame:CGRectMake(0, 80, 320, 350)];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    
    [self.cameraImagePickerController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)getLatestPhotoFromAlbum
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
//                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
//                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                
                self.albumImage =  [UIImage imageWithCGImage:[alAsset thumbnail]];
                
                
                // Stop the enumerations
                *stop = YES; *innerStop = YES;
                
                // Do something interesting with the AV asset.
                //[self sendTweet:latestPhoto];
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}




#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image,0.5);
    PFFile *imageFile = [PFFile fileWithName:@"Picked photo" data:imageData];
    self.pickedPhoto = [Image object];
    self.pickedPhoto.imageFile = imageFile;
    self.pickedPhoto.username = [User currentUser].username;
    [self.pickedPhoto saveInBackground];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        
        Comment *comment = [Comment object];
        comment.commentText = textView.text;
        comment.photo = self.pickedPhoto;
        comment.poster = (User *)[PFUser currentUser];
        [comment saveInBackground];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.pickedPhoto.comments addObject:comment];
            [self.pickedPhoto saveInBackground];
        }];
        
    }
    return YES;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.commentTextView resignFirstResponder];
}





@end
