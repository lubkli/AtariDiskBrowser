//
//  DiskImageFactory.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "DiskImageFactory.h"
#import "ATRImage.h"
#import "DCMImage.h"
#import "DIImage.h"
#import "SCPImage.h"
#import "XFDImage.h"

@implementation DiskImageFactory

+ (DiskImage*)mount:(NSString*)filename {
    NSString *ext = [[filename pathExtension] uppercaseString];
    DiskImage *image = nil;
    if ([ext isEqualToString:@"ATR"])
    {
        image = [[ATRImage alloc] init];
    }
    else if ([ext isEqualToString:@"DCM"])
    {
        image = [[DCMImage alloc] init];
    }
    else if ([ext isEqualToString:@"DI"])
    {
        image = [[DIImage alloc] init];
    }
    else if ([ext isEqualToString:@"SCP"])
    {
        image = [[SCPImage alloc] init];
    }
    else if ([ext isEqualToString:@"XFD"])
    {
        image = [[XFDImage alloc] init];
    }
    
    if (image != nil) {
        if ([image loadFromFile:filename] != 0) {
            image = nil;
        }
    }
    
    return image;
}

@end
