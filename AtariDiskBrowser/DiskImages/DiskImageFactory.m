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
#import "SCPImage.h"
#import "XFDImage.h"

@implementation DiskImageFactory

+ (DiskImage*)create:(NSString*)type {
    if ([type isEqualToString:@"ATR"])
    {
        return [[ATRImage alloc] init];
    }
    else if ([type isEqualToString:@"DCM"])
    {
        return [[DCMImage alloc] init];
    }
    else if ([type isEqualToString:@"SCP"])
    {
        return [[SCPImage alloc] init];
    }
    else if ([type isEqualToString:@"XFD"])
    {
        return [[XFDImage alloc] init];
    }
    else
        return nil;
}

@end
