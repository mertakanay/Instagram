//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *editUsernameTF;
@property (weak, nonatomic) IBOutlet UITextField *editFullNameTF;
@property (weak, nonatomic) IBOutlet UITextField *editEmailTF;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.editUsernameTF.text = self.currentUser.username;
    self.editFullNameTF.text = [self.currentUser objectForKey:@"name"];
    self.editEmailTF.text = self.currentUser.email;
    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        }
    }];


}
- (IBAction)onEditProfilePictureButtonPressed:(UIButton *)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select Image for Profile" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From library", @"From Camera", nil];

    [action showInView:self.view];
}

#pragma Mark - Choosing Image
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerView animated:YES completion:nil];

    }else if( buttonIndex == 1 ) {

        UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerView animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [self dismissViewControllerAnimated:picker completion:nil];

    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];

    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.imageView.image = image;
    self.currentUser.profileImage = imageFile;
    [self.currentUser.profileImage saveInBackground];

}

- (IBAction)onSaveButtonPressed:(UIButton *)sender
{
    self.currentUser.username = self.editUsernameTF.text;
    self.currentUser.fullName = self.editFullNameTF.text;
    self.currentUser.email = self.editEmailTF.text;

    [self.currentUser saveInBackground];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
