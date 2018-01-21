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
#import "PROImage.h"
#import "SCPImage.h"
#import "XFDImage.h"

@implementation DiskImageFactory

+ (DiskImage*)mount:(NSURL *)url {
//    NSError *err = nil;
//    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:url error:&err];
//    NSData *fileData = [handle readDataOfLength:4];
//    [handle closeFile];
//    unsigned char bytes[4];
//    [fileData getBytes:bytes length:4];

    unsigned char bytes[4];
    DiskImage *image;
    NSData *data = [NSData dataWithContentsOfURL:url];
    [data getBytes:bytes length:4];
    
    if (bytes[0] == 0x96 && bytes[1] == 0x02) {
        image = [[ATRImage alloc] initWithData:data];
    } else if (bytes[0] == 0xF9 || bytes[0] == 0xFA) {
        image = [[DCMImage alloc] initWithData:data];
    } else if (bytes[0] == 'D' && bytes[1] == 'I') {
        image = [[DIImage alloc] initWithData:data];
    } else if (bytes[2] == 'P' && bytes[3] == '2') {
        image = [[PROImage alloc] initWithData:data];
    } else if (bytes[2] == 'P' && bytes[3] == '3') {
        image = [[PROImage alloc] initWithData:data];
    } else {
        image = [[XFDImage alloc] initWithData:data];
    }
    
    return image;
}

@end
