//
//  User.h
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property NSString *username;
@property NSMutableArray *followingArray;
@property UIImage *profileImage;
@property NSString *fullName;
@property NSString *email;

@end
