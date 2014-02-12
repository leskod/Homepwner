//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

+(BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        allItems = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSArray *)allItems
{
    return allItems;
}

-(BNRItem *)createItem
{
    BNRItem *p = [BNRItem randomItem];
    
    [allItems addObject:p];
    
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

-(void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from==to)
    {
        return;
    }
    
    //get a pointer to the object being moved so we can reinsert it
    BNRItem *p = [allItems objectAtIndex:from];
    
    //remove it from the array
    [allItems removeObjectAtIndex:from];
    
    //insert p at the new location
    [allItems insertObject:p atIndex:to];
    
}





@end
