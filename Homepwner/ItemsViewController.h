//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsViewController.h"
#import "HomepwnerItemCell.h"



@interface ItemsViewController : UITableViewController
<UIPopoverControllerDelegate>

//-(id)initWithStyle:(UITableViewStyle):style;
{
//    IBOutlet UIView *headerView;
    UIPopoverController *imagePopover;
}
//
//-(UIView *) headerView;
-(IBAction)addNewItem:(id)sender;
//-(IBAction)toggleEditingMode:(id)sender;







@end
