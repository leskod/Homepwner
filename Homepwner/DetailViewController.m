//
//  DetailViewController.m
//  Homepwner
//
//  Created by Lesko, Dereck on 2/13/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"


//@interface DetailViewController ()
//
//@end

@implementation DetailViewController
@synthesize item;


-(void)setItem:(BNRItem *)i
{
    item=i;
    [[self navigationItem] setTitle:[item itemName]];
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]] ];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey)
    {
        //get the image for image key from image store
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        //use that image to put it on the screen in imageView
        [imageView setImage:imageToDisplay];
    }
    else
    {
        //clear the image
        [imageView setImage:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //clear first responder
    [[self view] endEditing:YES];
    
    //save changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}







//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    //if our device has a campera, we want to take a picture, otherwise, just pick it from the photo library
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    //place the image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:Nil];
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    //did the item already have an image?
    if (oldKey)
    {
        //delete the old image from the image store
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    
    //get the image from the dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //create a CFUUID object - it knows how to create the unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    //use the new unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    //store image in BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    
    //put the image on the screen
    [imageView setImage:image];
    
    //take the image picker off the screen - you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}










@end
