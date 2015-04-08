//
//  User.h
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface User : PFObject<PFSubclassing>

@property NSString *username;
@property NSString *password;
@property NSMutableArray *followingArray;
@property PFFile *profileImage;
@property NSString *fullName;
@property NSString *email;

+ (NSString *)parseClassName;

@end
