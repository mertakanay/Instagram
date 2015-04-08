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

@synthesize photos = _photos;
@synthesize followers = _followers;
@synthesize followings = _followings;
@synthesize comments = _comments;

+ (void)load {
    [self registerSubclass];
}

-(void)setPhotos:(PFRelation *)photos
{
    _photos = photos;
}

-(PFRelation *)photos
{
    if (!_photos) {
        _photos = [self relationForKey:@"photos"];
    }
    return _photos;
}

-(void)setFollowers:(PFRelation *)followers
{
    _followers = followers;
}

-(PFRelation *)followers
{
    if (!_followers) {
        _followers = [self relationForKey:@"followers"];
    }
    return _followers;
}

-(void)setFollowings:(PFRelation *)followings
{
    _followings = followings;
}

-(PFRelation *)followings
{
    if (!_followings) {
        _followings = [self relationForKey:@"followings"];
    }
    return _followings;
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
