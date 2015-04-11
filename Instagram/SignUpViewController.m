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

@property (weak, nonatomic) IBOutlet UIButton *chooseImageButton;
@property User *currentUser;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;

    self.currentUser = [User object];


    self.view.backgroundColor =[UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];

    self.chooseImageButton.tintColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];

    self.registerButton.layer.borderWidth=1.5f;
    self.registerButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.registerButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];
    self.cancelButton.layer.borderWidth=1.5f;
    self.cancelButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:178/255.0 blue:130/255.0 alpha:1.0];

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

    }else if ([self.passwordTextField.text length] < 6 || [self.confirmPasswordTextField.text length] < 6){

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

        //Indicator starts annimating when signing up. 
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color = [UIColor blueColor];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];

        [activityIndicator startAnimating];

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {


            //stop actiivity indication from annimating. 
            [activityIndicator stopAnimating];


            //if call is succcessful - let the user use the app and take them to next screen.
            if (!error)
            {
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     [self performSegueWithIdentifier:@"toSelectFirstTimeFollowers" sender:self];
                }];

                
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
    UINavigationController *followNavVC = [segue destinationViewController];
    FollowRecViewController *followVC = followNavVC.childViewControllers.firstObject;
    
    followVC.currentUser = self.currentUser;
    
}


@end
