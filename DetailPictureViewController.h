//
//  DetailPictureViewController.h
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface DetailPictureViewController : UIViewController

@property (nonatomic) Image *photo;
@property (nonatomic) UIImage *photoImage;
@property (nonatomic) UIImage *userProfileImage;

@end
