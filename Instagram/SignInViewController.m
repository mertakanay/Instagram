//
//  ViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SignInViewController.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <AudioToolbox/AudioServices.h>

@interface SignInViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;

    self.signinButton.layer.borderWidth=1.0f;
    self.signinButton.layer.borderColor=[[UIColor blackColor] CGColor];


    self.signUpButton.layer.borderWidth=1.0f;
    self.signUpButton.layer.borderColor=[[UIColor blackColor] CGColor];


}


//Helper method to display error to user.
-(void)displayAlert:(NSString *)error{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error in form" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];
    
}

//login action - when the user fills out the login form, perform a check if the textfields are empty..if they are then, display an alert. If no error continue to log the user in.
- (IBAction)onSignInButtonPressed:(UIButton *)sender
{

    NSString *loginError = @"";

    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {

        loginError = @"Please enter a valid username and password";

    }


    if (![loginError isEqualToString:@""]) {

        [self displayAlert:loginError];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{

        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color = [UIColor colorWithRed:194/255.0 green:223/255.0 blue:255/255.0 alpha:1.0];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];

        [activityIndicator startAnimating];

    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {

                                            [activityIndicator stopAnimating];

                                        if (user)
                                        {
                                            [self performSegueWithIdentifier:@"toMainScreen" sender:self];

                                        }else{
                                         NSString *errorString = [error userInfo][@"error"];


                                            [self displayAlert:errorString];
                                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);


                                        }


                                    }];

    }
    
}
- (IBAction)signUpButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toRegisterScene" sender:self];
}

//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//unwind from main view controller

- (IBAction)unwindToSignInViewController:(UIStoryboardSegue *)segue {
    //nothing goes here

    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}
























@end
