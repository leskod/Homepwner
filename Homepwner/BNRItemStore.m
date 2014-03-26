//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Lesko, Dereck on 2/11/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"


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
        //allItems = [[NSMutableArray alloc]init];
        
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //if the array hadn't been saved previously, create a new empty one.
        if (!allItems)
            allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)allItems
{
    return allItems;
}

-(BNRItem *)createItem
{
    //BNRItem *p = [BNRItem randomItem];
    BNRItem *p = [[BNRItem alloc] init];
    
    [allItems addObject:p];
    
    return p;
}

-(void)removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
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

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems
                                       toFile:path];
}



@end
