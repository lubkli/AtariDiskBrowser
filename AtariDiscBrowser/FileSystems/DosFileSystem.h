//
//  DosFileSystem.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "FileSystem.h"

@interface DosFileSystem : FileSystem

// Disk
//
//    Sector 1: Boot record
//    Sector 2-n: DOS.SYS file (on system disks)
//    Sector n+1-359: User file space
//    Sector 360: VTOC (Volume Table of Contents)
//    Sector 361-368: Directory
//    Sector 369-719: User file space
//    Sector 720: Unused

// Boot record
//
//    Sector 1 is the boot record. It has this structure:
//    Byte 0: 0 (representing boot flag)
//    Byte 1: 1 (representing the number of sectors the boot record takes)
//    Byte 2-3: Boot address (0700)
//    Byte 4-5: Init address
//    Byte 6: 4B (JMP command used with address in following 2 bytes)
//    Byte 7-8: Boot read continuation address
//    Byte 9: Max # of files open concurrently (1-8)
//    Byte 10: Specific drive numbers supported (bitmap where low-order bit means drive 1, next bit drive 2, and so on up to 4)
//    Byte 11: Buffer allocation direction (set to 0)
//    Byte 12-13: Boot image end address + 1
//    Byte 14: Boot flag (must be nonzero if DOS.SYS is on disk)
//    Byte 15: Sector count (not used)
//    Byte 16-17: DOS.SYS starting sector number
//    Byte 18-127: Code for second phase of boot

@end
