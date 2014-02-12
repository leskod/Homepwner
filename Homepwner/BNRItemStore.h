//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BNRItem;


@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}
+(BNRItemStore *)sharedStore;

-(NSArray *)allItems;
-(BNRItem *)createItem;




@end
