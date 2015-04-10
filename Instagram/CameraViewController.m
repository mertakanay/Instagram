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
#import "Comment.h"
#import "Image.h"


@interface CameraViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) UIButton *libraryButton;
@property (nonatomic) UIImageView *libraryImageView;
@property (nonatomic) UIImagePickerController *cameraImagePickerController;
@property (nonatomic) UIImagePickerController *libraryImagePickerController;

@property (nonatomic) UIImage *albumImage;
@property (nonatomic) UIButton *cameraButton;

@property (nonatomic) Image *pickedPhoto;
@property (nonatomic) BOOL shouldHideCamera;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentTextView layer] setBorderWidth:2.3];
    [[self.commentTextView layer] setCornerRadius:15];
    self.commentTextView.textColor = [UIColor lightGrayColor];

}

-(void)viewWillAppear:(BOOL)animated
{
    if (!self.shouldHideCamera) {
        self.view.hidden = YES;
        [self getLatestPhotoFromAlbum];
        [self presentCamera];
    }
}



-(void)presentCamera
{

    self.cameraImagePickerController = [UIImagePickerController new];
    self.cameraImagePickerController.delegate = self;
    self.cameraImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraImagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    self.cameraImagePickerController.showsCameraControls=YES;  //we will make custom controls.
    
    [self presentViewController:self.cameraImagePickerController animated:YES completion:nil];
    
    
    self.libraryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(253, 505, 50, 50)];
//    [self.libraryImageView setNeedsDisplay];
    self.libraryImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoLibrary:)];
    [self.libraryImageView addGestureRecognizer:tapGesture];
    self.libraryImageView.image = self.albumImage;
    [self.cameraImagePickerController.view addSubview:self.libraryImageView];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(112, 480, 100, 100)];
//    [self.cameraButton setTitle:@"TakePhoto" forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.cameraButton setTintColor:[UIColor whiteColor]];
    [self.cameraButton setBackgroundColor:[UIColor clearColor]];
    [self.cameraButton addTarget:self action:@selector(shootPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraImagePickerController.view addSubview:self.cameraButton];
    

}

-(void)cancelPicker
{
    //get rid of the image picker
    [self dismissViewControllerAnimated:YES completion:nil]; //dismiss uiimagepicker
    self.cameraImagePickerController=nil;
}

//take the picture, it will then go directly to - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info method
-(void)shootPicture
{
    self.libraryImageView.hidden = YES;
    self.cameraButton.hidden = YES;
    [self.cameraImagePickerController takePicture];
    self.cameraImagePickerController.showsCameraControls=NO;  //we will make custom controls.
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
                self.libraryImageView.image = self.albumImage;
                
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
   
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image,0.5);
    PFFile *imageFile = [PFFile fileWithName:@"Picked photo" data:imageData];
    self.pickedPhoto = [Image object];
    self.pickedPhoto.imageFile = imageFile;
    [self.pickedPhoto saveInBackground];
    self.shouldHideCamera = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.view.hidden = NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];

}

- (IBAction)onDoneButtonTapped:(UIButton *)sender
{

    if (self.commentTextView.text.length) {
        Comment *comment = [Comment object];
        comment.commentText = self.commentTextView.text;
        comment.photo = self.pickedPhoto;
        comment.poster = (User *)[PFUser currentUser];
        [comment saveInBackground];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.pickedPhoto.comments addObject:comment];
            [self.pickedPhoto saveInBackground];
        }];
    }
    [self.tabBarController setSelectedIndex:0];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.commentTextView resignFirstResponder];
}


@end
