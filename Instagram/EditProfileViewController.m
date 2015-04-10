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
@property (weak, nonatomic) IBOutlet UIButton *editProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];

    self.editProfilePictureButton.layer.borderWidth=1.5f;
    self.editProfilePictureButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.editProfilePictureButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];

    self.saveButton.layer.borderWidth=1.5f;
    self.saveButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.saveButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];

    self.editUsernameTF.text = self.currentUser.username;
    self.editUsernameTF.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];
    self.editFullNameTF.text = [self.currentUser objectForKey:@"name"];
    self.editFullNameTF.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];
    self.editEmailTF.text = self.currentUser.email;
    self.editEmailTF.backgroundColor = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];
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
