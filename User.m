//
//  User.m
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

@dynamic username;
@dynamic password;
@dynamic email;
@dynamic profileImage;
@dynamic fullName;
@dynamic followingArray;


-(instancetype)initWithClassName:(NSString *)newClassName{



    return self;
}

+ (void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"User";
}


@end
