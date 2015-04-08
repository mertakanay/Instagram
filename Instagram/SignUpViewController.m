//
//  SignUpViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "FollowRecViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageVC;

@property User *currentUser;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;

    self.currentUser = [User new];

}


//Helper method to display error to user.
-(void)displayAlert:(NSString *)error{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error in form" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)chooseImageButtonTapped:(UIButton *)sender {

    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select Image for Profile" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From library", @"From Camera", nil];

    [action showInView:self.view];

}
- (IBAction)onRegisterButtonPressed:(UIButton *)sender
{
    NSString *signUpError = @"";


    //first need to check if any of the fields are empty.

    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.confirmPasswordTextField.text isEqualToString:@""] || [self.fullNameTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""]) {

        signUpError = @"One or more fields are blank. Please try again!";

    }else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){

        signUpError = @"Passwords do not match, please try again.";

    }else if ([self.passwordTextField.text length] < 1 || [self.confirmPasswordTextField.text length] < 1){

        signUpError = @"Password must be at least 8 characters long. Please try again.";

    }else {

        //declare all the parse variables needed sign up our user.
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        user[@"name"] = self.fullNameTextField.text;


        //profile image saving
       // NSData *imageData = UIImagePNGRepresentation(self.currentUser.profileImage);
        PFFile *imageFile = self.currentUser.profileImage;
        user[@"profileImage"] = imageFile;

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            //if call is succcessful - let the user use the app and take them to next screen.
            if (!error)
            {
                [self performSegueWithIdentifier:@"toSelectFirstTimeFollowers" sender:self];
                
            } else {
                //else diplay an alert to the user.

                NSString *errorString = [error userInfo][@"error"];
                //signUpError = errorString;
                [self displayAlert:errorString];


            }
        }];
        
    }

    //display the error message
    if (![signUpError isEqualToString:@""]) {
        [self displayAlert:signUpError];
    }

}

#pragma Mark - ActionSheet Delegates for Choosing Image. 
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

#pragma Marks - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [self dismissViewControllerAnimated:picker completion:nil];

    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];

    NSData *imageData = UIImagePNGRepresentation(img);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.currentUser.profileImage = imageFile;
    self.profileImageVC.image = img;
    [self.currentUser.profileImage saveInBackground];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FollowRecViewController *followRVC = [segue destinationViewController];
    followRVC.currentUser = self.currentUser;
    
}

@end
