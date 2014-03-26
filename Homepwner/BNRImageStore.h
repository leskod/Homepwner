//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Lesko, Dereck on 2/18/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

//this makes it be a singleton class
+(BNRImageStore *)sharedStore;

-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;

-(NSString *)imagePathForKey:(NSString *)key;


@end
