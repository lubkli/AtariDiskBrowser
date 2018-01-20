//
//  ATRFile.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 08/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//
// Nick Kennedy's SIO2PC Atari Disk Image format is the defaco standard disk image, used by APE, SIO2PC, and all Atari emulators.

#import <Foundation/Foundation.h>
#import "DiskImage.h"

@interface ATRImage : DiskImage {
    uint16_t highSize;
    uint8_t diskFlags;
    uint16_t badSect;
}

@end
