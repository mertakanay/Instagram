//
//  Image.h
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Image : PFObject<PFSubclassing>

@property NSString *username;
@property NSString *imageDescription;
@property PFFile *imageFile;
@property NSMutableArray *commentsArray;
@property NSMutableArray *likersArray;

@property (nonatomic) User *postUser;
@property (nonatomic) PFRelation *likers;
@property (nonatomic) PFRelation *comments;

+ (NSString *)parseClassName;

@end
