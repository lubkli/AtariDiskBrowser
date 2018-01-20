//
//  XFDImage.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//
// Xformer Disk Image is image similar to the ATR but lacks the ID and format header, it is essentially a large unmarked blob of data. Compatible only with the PC-Xformer emulator.

#import <Foundation/Foundation.h>
#import "DiskImage.h"

@interface XFDImage : DiskImage

@end
