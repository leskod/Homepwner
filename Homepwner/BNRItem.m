//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Lesko, Dereck on 1/23/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize containedItem, container, serialNumber, valueInDollars, dateCreated;


+(id)randomItem
{
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac", nil];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() %10,
                                    '0' + rand() %26,
                                    '0' + rand() %10,
                                    '0' + rand() %26,
                                    '0' + rand() %10
                                    ];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
    
}

-(id)init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

-(id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:sNumber];
}

-(id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self=[super init];
    
    if (self){
    [self setItemName:name];
    [self setValueInDollars:value];
    [self setSerialNumber:sNumber];
    dateCreated = [[NSDate alloc]init];
    }
    
    return self;
}

-(void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}



-(void)SetContainedItem:(BNRItem *)i
{
    containedItem = i;
    
    //when given an item to contain, the contained
    //item will be given a pointer to its container
    [i setContainer:self];
}
//-(BNRItem *)containedItem
//{
//    return containedItem;
//}
//
//-(void)setContainer:(BNRItem *)i
//{
//    container = i;
//}
//-(BNRItem *)container
//{
//    return container;
//}
//
//
//
//
//
//
//-(void)setItemName:(NSString *)str
//{
//    itemName = str;
//}
//-(NSString *)itemName
//{
//    return itemName;
//}
//
//-(void)setSerialNumber:(NSString *)str
//{
//    serialNumber = str;
//}
//-(NSString *)serialNumber
//{
//    return serialNumber;
//}
//
//-(void)setValueInDollars:(int)i
//{
//    valueInDollars=i;
//}
//-(int)valueInDollars
//{
//    return valueInDollars;
//}
//
//-(NSDate *)dateCreated
//{
//    return dateCreated;
//}

-(NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"@%@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber,
     valueInDollars,
     dateCreated];
    
    return descriptionString;
}






@end
