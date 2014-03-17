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
#import "BNRItemStore.h"


//@interface DetailViewController ()
//
//@end

@implementation DetailViewController
@synthesize item;
@synthesize dismissBlock;


-(id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self)
    {
        if (isNew)
        {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                            target:self
                                            action:@selector(cancel:)];
                                           [[self navigationItem]setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong Initializer"
            reason:@"Use initForNewItem:"
                                 userInfo:nil];
}

-(void)setItem:(BNRItem *)i
{
    item=i;
    [[self navigationItem] setTitle:[item itemName]];
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    //[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }else{
        clr=[UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:clr];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        return YES;
    }else{
        return (io==UIInterfaceOrientationPortrait);
    
    }
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
    if([imagePickerPopover isPopoverVisible]){
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    
    imagePicker.allowsEditing = YES;
    
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
    //[self presentViewController:imagePicker animated:YES completion:Nil];


    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller; sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    }
    else
    {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction)clearImage:(id)sender
{
    if ([item imageKey]) {
        
        // Remove the image from the screen
        [imageView setImage:nil];
        
        // Delete the image form the image store
        [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
        
        // Delete the imageKey of the item
        [item setImageKey:nil];
    }
}

//this is like a callback...or handling an event when an image is picked.
//the image picker controller calls this method which allows us to do things with the image, like displaying (setImage) it
-(void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    //did the item already have an image?
    if (oldKey)
    {
        //delete the old image from the image store
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    
    //get the image from the dictionary
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //create a CFUUID object - it knows how to create the unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    //use the new unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    //store image in BNRImageStore Dictionary with this key
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    
    //
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    
    //put the image on the screen
    [imageView setImage:image];
    
    //take the image picker off the screen - you must call this dismiss method
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom  ] == UIUserInterfaceIdiomPhone)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)save:(id)sender
{
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

-(void)cancel:(id)sender
{
    //if user canceleled, remove from the store
    [[BNRItemStore sharedStore] removeItem:item];
    
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}





@end
