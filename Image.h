//
//  Image.h
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Image : PFObject<PFSubclassing>

@property NSString *username;
@property NSString *imageDescription;
@property PFFile *imageFile;
@property NSMutableArray *commentsArray;
@property NSMutableArray *likersArray;

+ (NSString *)parseClassName;

@end
