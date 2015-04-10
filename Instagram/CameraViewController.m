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
#import "PreparePhotoViewController.h"


@interface CameraViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, PreparePhotoViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
//@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) UIButton *libraryButton;
@property (nonatomic) UIImageView *libraryImageView;
@property (nonatomic) UIButton *cameraButton;
@property (nonatomic) UIImagePickerController *cameraImagePickerController;
@property (nonatomic) UIImagePickerController *libraryImagePickerController;

@property (nonatomic) UIImage *albumImage;

@property (nonatomic) Image *pickedPhoto;

@property (nonatomic) PreparePhotoViewController *preparePhotoVC;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
//    [[self.commentTextView layer] setBorderWidth:2.3];
//    [[self.commentTextView layer] setCornerRadius:15];
//    self.commentTextView.textColor = [UIColor lightGrayColor];
//    
//    self.view.hidden = YES;
    
    


}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self getLatestPhotoFromAlbum];
    [self presentCamera];
    
}


-(void)presentCamera
{

    self.cameraImagePickerController = [UIImagePickerController new];
    self.cameraImagePickerController.delegate = self;
    self.cameraImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraImagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    self.cameraImagePickerController.showsCameraControls=YES;  //we will make custom controls.
    
    [self presentViewController:self.cameraImagePickerController animated:YES completion:nil];
    

    
//    self.libraryButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 450, 100, 30)];
//    [self.libraryButton setTitle:@"Library" forState:UIControlStateNormal];
//    [self.libraryButton setTintColor:[UIColor whiteColor]];
//    [self.libraryButton setBackgroundColor:[UIColor clearColor]];
//    [self.libraryButton addTarget:self action:@selector(gotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
//    self.libraryButton.hidden = NO;
//    [self.cameraImagePickerController.view addSubview:self.libraryButton];
//
    self.libraryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 505, 50, 50)];
//    [self.libraryImageView setNeedsDisplay];
    self.libraryImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoLibrary:)];
    [self.libraryImageView addGestureRecognizer:tapGesture];
    self.libraryImageView.image = self.albumImage;
    [self.cameraImagePickerController.view addSubview:self.libraryImageView];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 480, 100, 100)];
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
    self.cameraImagePickerController.showsCameraControls = NO;
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
   
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.preparePhotoVC= [storyboard instantiateViewControllerWithIdentifier:@"PreparePhotoVCId"];
    self.preparePhotoVC.photo = info[UIImagePickerControllerOriginalImage];
    self.preparePhotoVC.tabBarController = self.tabBarController;
    self.preparePhotoVC.delegate = self;
    [self presentViewController:self.preparePhotoVC animated:YES completion:nil];
    


//    self.view.hidden = NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];

}

-(void)preparePhotoViewControllerShouldDismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}


@end
