//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Lesko, Dereck on 3/26/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "HomepwnerItemCell.h"


@implementation HomepwnerItemCell

@synthesize controller;
@synthesize tableView;


- (IBAction)showImage:(id)sender
{
    
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
//    [[self controller] showImage:sender
//                     atIndexPath:indexPath];
    if(indexPath)
    {
        if([[self controller] respondsToSelector:newSelector])
        {
            [controller performSelector:newSelector
                             withObject:sender
                             withObject:indexPath];
        }
    }
}
@end
