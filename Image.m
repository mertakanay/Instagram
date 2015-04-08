//
//  Image.m
//  Instagram
//
//  Created by Ronald Hernandez on 4/7/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "Image.h"

@implementation Image

@dynamic username;
@dynamic imageDescription;
@dynamic imageFile;
@dynamic commentsArray;
@dynamic likersArray;

-(instancetype)initWithClassName:(NSString *)newClassName{

    return self;
}

+ (void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Image";
}

@end
