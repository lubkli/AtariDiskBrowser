//
//  DiskImage.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

//  Disk types:
//  Density  sides TPS SPT BPS enc total bytes
//  SD         1   40  18  128 FM  92160 (90K)   ...Single-Sided, Single-Density: 40 tracks with 18 sectors per track, 128 bytes per sector. 90 KB capacity.
//  ED         1   40  26  128 MFM 133120 (130K) ...Single-Sided, Enhanced-Density: 40 tracks with 26 sectors per track, 128 bytes per sector. 130 KB capacity. Readable by the 1050 and the XF551.
//  SS/DD      1   40  18  256 MFM 184320 (180K) ...Single-Sided, Double-Density: 40 tracks with 18 sectors per track, 256 bytes per sector. 180 KB capacity. Readable by the XF551, the 815, or modified/upgraded 1050.
//  DS/DD      2   40  18  256 MFM 368640 (360K) ...Double-Sided, Double-Density: 80 tracks (40 tracks per side) with 18 sectors per track, 256 bytes per sector. 360 KB capacity. Readable by the XF551 only.

#import <Foundation/Foundation.h>
#import "AtariFile.h"
#import "BinaryReader.h"
#import "FileSystem.h"

@interface DiskImage : NSObject {
    BinaryReader *reader;
    FileSystem *_system;
    NSUInteger _headerSize;
    NSUInteger _diskSize;
    NSUInteger _sectorSize;
}

@property (readonly) NSUInteger headerSize;
@property (readonly) NSUInteger diskSize;
@property (readonly) NSUInteger sectorSize;
@property (readonly) FileSystem *system;

- (BOOL)readHeader;

- (NSInteger)mount:(NSString *)fileName;
- (NSData *)readFile:(NSString *)fileName;

@end
