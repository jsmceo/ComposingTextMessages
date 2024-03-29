//
//  ViewController.m
//  ComposingTextMessages
//
//  Created by John Malloy on 8/2/14.
//  Copyright (c) 2014 BigRedINC. All rights reserved.
//

#import "ViewController.h"
#import "DTPageRenderer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputTextView.layer.cornerRadius = 15.0;
    self.imageView.layer.cornerRadius = 15.0;
    
    self.inputTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textMessagingAvailabilityChanged)
                                                 name:MFMessageComposeViewControllerTextMessageAvailabilityDidChangeNotification
                                               object:nil];
}

-(void)textMessagingAvailabilityChanged:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        NSLog(@"Text Messaging Available");
    }
    else
    {
        NSLog(@"Text Messaging Is Not Available");
    }
}


- (IBAction)textMessage:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        messageVC.recipients = @[@"3015555309"];
        messageVC.body = self.inputTextView.text;
        [self presentViewController:messageVC animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Text Message Unavailable");
    }
}

- (IBAction)mailMessage:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController * mailVC = [[MFMailComposeViewController alloc] init];
        [mailVC setSubject:@"Send it Out"];
        [mailVC setToRecipients:@[@"test@example.com"]];
        [mailVC setMessageBody:self.inputTextView.text isHTML:NO];
        mailVC.mailComposeDelegate = self;
        
        if (self.imageView.image != nil)
        {
            NSData * imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
            [mailVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"SelectedImage"];
        }
        
        [self presentViewController:mailVC animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Email Is Not Available");
    }
}

- (IBAction)getImage:(id)sender
{
    self.picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.delegate = self;
        
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}

- (IBAction)print:(id)sender
{
    if ([UIPrintInteractionController isPrintingAvailable] && (self.imageView.image != nil))
    {
        UIPrintInteractionController * pic = [UIPrintInteractionController sharedPrintController];
        
        UIPrintInfo * printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputPhoto;
        printInfo.jobName = self.title;
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        
        UIImage * image = self.imageView.image;
        pic.printingItem = image;
        
        if (!pic.printingItem && image.size.width > image.size.height)
            printInfo.orientation = UIPrintInfoOrientationLandscape;
        
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * printInteractionController, BOOL completed, NSError * error)
         {
             if (!completed && (error != nil))
             {
                 NSLog(@"Error Printing: %@", error);
             }
             
             else
                 
             {
                 NSLog(@"Printing Job Completed");
             }
         }];
            
    }
}

- (IBAction)printText:(id)sender
{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController * pic = [UIPrintInteractionController sharedPrintController];
        
        UIPrintInfo * printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = self.title;
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        
        UISimpleTextPrintFormatter * simpleTextPf = [[UISimpleTextPrintFormatter alloc] initWithText:self.inputTextView.text];
        simpleTextPf.startPage = 0;
        simpleTextPf.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
        simpleTextPf.maximumContentWidth = 6 * 72.0;
        
        pic.printFormatter = simpleTextPf;
        
        pic.showsPageRange = YES;
        
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * printInteractionController, BOOL completed, NSError * error)
         {
             if (!completed && (error != nil))
             {
                 NSLog(@"Error Printing: %@", error);
             }
             else
             {
                 NSLog(@"Printing Completed");
             }
         }];
    }
}

- (IBAction)printViewPressed:(id)sender
{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController * pic = [UIPrintInteractionController sharedPrintController];
        
        UIPrintInfo * printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = self.title;
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printInfo.orientation = UIPrintInfoOrientationLandscape;
        pic.printInfo = printInfo;
        
        UIViewPrintFormatter * viewPF = [self.inputTextView viewPrintFormatter];
        
        pic.printFormatter = viewPF;
        pic.showsPageRange = YES;
        
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * printInteractionController, BOOL completed, NSError * error)
         {
             if (!completed && (error != nil))
             {
                 NSLog(@"Error Printing View: %@", error);
             }
             else
             {
                 NSLog(@"Printing Completed");
             }
         }]; 
    }
}

- (IBAction)printCustom:(id)sender

{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController * pic = [UIPrintInteractionController sharedPrintController];
        
        UIPrintInfo * printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = self.title;
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printInfo.orientation = UIPrintInfoOrientationPortrait;
        pic.printInfo = printInfo;
        
        UISimpleTextPrintFormatter * simplePF = [[UISimpleTextPrintFormatter alloc] initWithText:[self.inputTextView.text stringByAppendingString:@"iOS 7 Recipes"]];
        
        DTPageRenderer * sendPR = [[DTPageRenderer alloc] init];
        sendPR.title = @"My Print Job Title";
        sendPR.author = @"Document Author";
        sendPR.headerHeight = 72.0/2;
        sendPR.footerHeight = 72.0/2;
        
        [sendPR addPrintFormatter:simplePF startingAtPageAtIndex:0];
        
        pic.printPageRenderer = sendPR;
        
        pic.showsPageRange = YES;
        
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * printInteractionController, BOOL completed, NSError * error)
         {
             if (!completed && (error != nil))
             {
                 NSLog(@"Error Printing: %@", error);
             }
             else
             {
                 NSLog(@"Printing Completed");
             }
         }];
    }
}

- (IBAction)printView:(id)sender {
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent)
    {
        self.inputTextView.text = @"Message Sent";
    }
    else if (result == MessageComposeResultFailed)
    {
        NSLog(@"Failed To Send The Message");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//The following method is required when using MFMailComposeViewControllerDelegate protocol

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent)
    {
        self.inputTextView.text = @"Mail Sent";
        self.imageView.image = nil;
    }
        else if (result == MFMailComposeResultCancelled)
            NSLog(@"Mail Was Cancelled");
        else if (result == MFMailComposeResultFailed)
            NSLog(@"Error, Mail Send Failed");
        else if (result == MFMailComposeResultSaved)
            NSLog(@"Mail Was Saved");
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

//Following 2 methods are required for UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

@end
