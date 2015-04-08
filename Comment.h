//
//  Comment.h
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Image.h"

@interface Comment : PFObject<PFSubclassing>

@property NSString *username;
@property NSString *commentText;

@property (nonatomic) Image *photo;
@property (nonatomic) User *poster;

+ (NSString *)parseClassName;

@end
