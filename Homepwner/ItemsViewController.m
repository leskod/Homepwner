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


@implementation ItemsViewController




- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
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


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    //check for a reusable cell first
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    //if there's no reusable cell, create a new one
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *p = [[[BNRItemStore sharedStore]allItems]
                  objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p description]];
    
    return cell;
}

-(UIView *)headerView
{
    if (!headerView)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}

-(CGFloat)tableView:(UITableView *) tv heightForHeaderInSection:(NSInteger)sec
{
    return [[self headerView] bounds].size.height;
}

-(IBAction)toggleEditingMode:(id)sender
{
    if (([self isEditing]))
    {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self setEditing:NO animated:YES];
    }
    else
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setEditing:YES animated:YES];
    }
}

-(IBAction)addNewItem:(id)sender
{
    //make a new index position for the 0th section, last row
    //int lastRow = [[self tableView] numberOfRowsInSection:0];
    
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    //figure out where that item is in the array
    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //insert the new row into the table
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
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



@end
