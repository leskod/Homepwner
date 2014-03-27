//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"

#import "BNRImageStore.h"
#import "ImageViewController.h"


@implementation ItemsViewController




- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"Homepwner"];
        
        //create a new bar button item that will send
        //addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        //set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
    
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        
        
//        [[self navigationItem] setLeftBarButtonItem:bbi];
//        
//        [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView
                     numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allItems]count];
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
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
//    //check for a reusable cell first
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    
//    //if there's no reusable cell, create a new one
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
    
    BNRItem *p = [[[BNRItemStore sharedStore]allItems]
                  objectAtIndex:[indexPath row]];
    
//    [[cell textLabel] setText:[p description]];
    
    
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    
    return cell;
}

////removed because we added the navigation bar buttons
//-(UIView *)headerView
//{
//    if (!headerView)
//    {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return headerView;
//}

////removed because we added the navigation bar buttons
//-(UIView *)tableView:(UITableView *)tv
//viewForHeaderInSection:(NSInteger)sec
//{
//    return [self headerView];
//}
//
////removed because we added the navigation bar buttons
//-(CGFloat)tableView:(UITableView *) tv
//heightForHeaderInSection:(NSInteger)sec
//{
//    return [[self headerView] bounds].size.height;
//}
//
////removed because we added the navigation bar buttons
//-(IBAction)toggleEditingMode:(id)sender
//{
//    if (([self isEditing]))
//    {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        [self setEditing:NO animated:YES];
//    }
//    else
//    {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        
//        [self setEditing:YES animated:YES];
//    }
//}

-(IBAction)addNewItem:(id)sender
{
    //make a new index position for the 0th section, last row
    //int lastRow = [[self tableView] numberOfRowsInSection:0];
    
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
//    
//    //figure out where that item is in the array
//    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
//    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    //insert the new row into the table
//    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
//                            withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        //we also need to remove that row from the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
     toIndex:[destinationIndexPath row]];
}









-(void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailViewController *detailViewController = [[DetailViewController alloc] init];
    DetailViewController *detailViewController = [[DetailViewController alloc]initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    //give the detail view controller a pointer to the item object in row
    //remember, item is a @synthesized property, so setItem gets created for us
    [detailViewController setItem:selectedItem];
    //does the same thing
    //detailViewController.item = selectedItem;
    
    
    //push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //reload the data if it changed.
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //load the nib file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    //register this NIB
    [[self tableView] registerNib: nib
           forCellReuseIdentifier:@"HomepwnerItemCell"];
    
}

-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"Going to show the image for %@",ip);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
    
    // Get the item for the index path
    BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
    
    NSString *imageKey = [i imageKey];
    
    // If there is no image, we don't need to display anything
    UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
    if(!img)
        return;
    
    // Make a rectangle that the frame of the button relative to
    // our table view
    CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
    
    // Create a new ImageViewController and set its image
    ImageViewController *ivc = [[ImageViewController alloc] init];
    [ivc setImage:img];
    
    // Present a 600x600 popover
    imagePopover = [[UIPopoverController alloc]
                    initWithContentViewController:ivc];
    [imagePopover setDelegate:self];
    [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
    [imagePopover presentPopoverFromRect:rect
                                  inView:[self view]
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
    }
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}


@end
