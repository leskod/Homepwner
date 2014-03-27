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
@synthesize imageKey;
@synthesize thumbnail, thumbnailData;


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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
        
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


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    
}


- (UIImage *)thumbnail
{
    if(!thumbnailData)
        return nil;
    
    if(!thumbnail)
        thumbnail = [UIImage imageWithData:thumbnailData];
    
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}



@end
