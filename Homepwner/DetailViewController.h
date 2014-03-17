//
//  DetailViewController.h
//  Homepwner
//
//  Created by Lesko, Dereck on 2/13/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    //@property (weak, nonatomic) IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;

    __weak IBOutlet UIImageView *imageView;
    
    UIPopoverController *imagePickerPopover;
    
    

}
-(id)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong)BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);


- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)clearImage:(id)sender;


@end
