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

#define     ATR_MAGIC1  0x96
#define     ATR_MAGIC2  0x02

/* ATR format header */
struct ATR_header {
    unsigned char magic1;
    unsigned char magic2;
    unsigned char seccountlo;
    unsigned char seccounthi;
    unsigned char secsizelo;
    unsigned char secsizehi;
    unsigned char hiseccountlo;
    unsigned char hiseccounthi;
    unsigned char gash[7];
    unsigned char writeprotect;
};

@interface ATRImage : DiskImage {
    struct ATR_header header;
    uint16_t highSize;
    uint8_t diskFlags;
    uint16_t badSect;
}

- (BOOL)readHeader;
- (void)update;
- (void)makeHeaderWithSectorSize:(NSUInteger)sectorsize andSectorCount:(int)sectorcount;

@end
