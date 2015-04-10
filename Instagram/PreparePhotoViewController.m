//
//  PreparePhotoViewController.m
//  Instagram
//
//  Created by zhenduo zhu on 4/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "PreparePhotoViewController.h"

#import "Comment.h"
#import "Image.h"


@interface PreparePhotoViewController() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) Image *pickedPhoto;


@end


@implementation PreparePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTextView.delegate = self;
    
     [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentTextView layer] setBorderWidth:2.3];
    [[self.commentTextView layer] setCornerRadius:15];
    self.commentTextView.textColor = [UIColor lightGrayColor];
    
    
    self.imageView.image = self.photo;
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image,0.5);
    PFFile *imageFile = [PFFile fileWithName:@"Picked photo" data:imageData];
    self.pickedPhoto = [Image object];
    self.pickedPhoto.imageFile = imageFile;
    [self.pickedPhoto saveInBackground];

}

- (IBAction)onDoneButtonTapped:(UIButton *)sender
{
    
    if (self.commentTextView.text.length) {
        Comment *comment = [Comment object];
        comment.commentText = self.commentTextView.text;
        comment.photo = self.pickedPhoto;
        comment.poster = (User *)[PFUser currentUser];
        [comment saveInBackground];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.pickedPhoto.comments addObject:comment];
            [self.pickedPhoto saveInBackground];
        }];
    }
    
    [self.delegate preparePhotoViewControllerShouldDismiss];

}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.commentTextView resignFirstResponder];
}

@end
