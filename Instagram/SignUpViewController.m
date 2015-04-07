//
//  SignUpViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
    
}
- (IBAction)onRegisterButtonPressed:(UIButton *)sender
{
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
//    user.email = self.emailTextField.text;

    // other fields can be set just like with PFObject
//    user[@"phone"] = @"415-392-0202";

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@",errorString);
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
