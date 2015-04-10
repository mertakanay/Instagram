//
//  PreparePhotoViewController.h
//  Instagram
//
//  Created by zhenduo zhu on 4/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PreparePhotoViewController;
@protocol PreparePhotoViewControllerDelegate <NSObject>

-(void)preparePhotoViewControllerShouldDismiss;

@end

@interface PreparePhotoViewController : UIViewController

@property id<PreparePhotoViewControllerDelegate> delegate;
@property (nonatomic) UIImage *photo;
@property (nonatomic) UITabBarController *tabBarController;

@end
