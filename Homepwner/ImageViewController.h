//
//  ImageViewController.h
//  Homepwner
//
//  Created by Lesko, Dereck on 3/27/14.
//  Copyright (c) 2014 Lesko, Dereck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    
    __weak IBOutlet UIImageView *imageView;
    
    __weak IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) UIImage *image;



@end
