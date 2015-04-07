//
//  ViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
}
- (IBAction)onSignInButtonPressed:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user)
                                        {

                                        }else{
                                            NSLog(@"%@",error);
                                        }
                                    }];

}
- (IBAction)onSignUpButtonPressed:(UIButton *)sender
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
