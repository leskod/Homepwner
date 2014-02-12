//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController

//-(id)initWithStyle:(UITableViewStyle):style;
{
    IBOutlet UIView *headerView;
}

-(UIView *) headerView;
-(IBAction)addNewItem:(id)sender;
-(IBAction)toggleEditingMode:(id)sender;







@end
