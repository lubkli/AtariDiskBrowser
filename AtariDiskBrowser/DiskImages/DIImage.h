//
//  DIImage.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 21/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "DiskImage.h"

#define     DI_MAGIC1  'D'
#define     DI_MAGIC2  'I'

struct DI_header1 {
    unsigned char magic1;
    unsigned char magic2;
    unsigned char verlo;
    unsigned char verhi;
};

struct DI_header2 {
    unsigned char reserved1;
    unsigned char tracks;
    unsigned char secpertrackhi;
    unsigned char secpertracklo;
    unsigned char flagshi;
    unsigned char flagslo;
    unsigned char secSizehi;
    unsigned char secSizelo;
    unsigned char reserved2;
};

@interface DIImage : DiskImage {
    struct DI_header1 header1;
    struct DI_header2 header2;
    NSString *creator;
    NSData *sectorTable;
}

@end
