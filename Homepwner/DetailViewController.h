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
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    //@property (weak, nonatomic) IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;

    __weak IBOutlet UIImageView *imageView;
    
    

}
@property (nonatomic, strong)BNRItem *item;


- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;


@end
