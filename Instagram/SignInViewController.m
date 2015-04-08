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


@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;


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

        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
