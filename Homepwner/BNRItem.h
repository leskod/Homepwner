//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Lesko, Dereck on 1/23/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    // These all got synthesized
//    NSString *itemName;
//    NSString *serialNumber;
//    int valueInDollars;
//    NSDate *dateCreated;
//    
//    BNRItem *containedItem;
//    __weak  BNRItem *container;
    
}

+(id)randomItem;


-(id)initWithItemName:(NSString *)name
         serialNumber:(NSString *)sNumber;

-(id)initWithItemName:(NSString *)name
       valueInDollars:(int)value
         serialNumber:(NSString *)sNumber;



//-(void)setContainedItem:(BNRItem *)i;
//-(BNRItem *)containedItem;

//-(void)setContainer:(BNRItem *)i;
//-(BNRItem *)container;




//-(void)setItemName:(NSString *)str;
//-(NSString *)itemName;

//-(void)setSerialNumber:(NSString *)str;
//-(NSString *)serialNumber;

//-(void)setValueInDollars:(int)i;
//-(int)valueInDollars;

//-(NSDate *)dateCreated;

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;




@end
