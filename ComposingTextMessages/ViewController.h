//
//  ViewController.h
//  ComposingTextMessages
//
//  Created by John Malloy on 8/2/14.
//  Copyright (c) 2014 BigRedINC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *textMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *mailMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *getImageButton;

@property (strong, nonatomic) UIImagePickerController * picker;


- (IBAction)textMessage:(id)sender;
- (IBAction)mailMessage:(id)sender;
- (IBAction)getImage:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)printText:(id)sender;
- (IBAction)printViewPressed:(id)sender;
- (IBAction)printCustom:(id)sender;





@end
