//
//  Comment.m
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic username;
@dynamic commentText;

-(instancetype)initWithClassName:(NSString *)newClassName{

    return self;
}

+ (void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Comment";
}

@end
