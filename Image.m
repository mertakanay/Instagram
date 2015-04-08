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
@dynamic owner;

@synthesize likers = _likers;
@synthesize comments = _comments;




+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Image";
}

-(void)setLikers:(PFRelation *)likers
{
    _likers = likers;
}

-(PFRelation *)likers
{
    if (!_likers) {
        _likers = [self relationForKey:@"likers"];
    }
    return _likers;
}

-(void)setComments:(PFRelation *)comments
{
    _comments = comments;
}

-(PFRelation *)comments
{
    if (!_comments) {
        _comments = [self relationForKey:@"comments"];
    }
    return _comments;
}

@end
