//
//  FileSystem.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtariFile.h"
#import "BinaryReader.h"

@interface FileSystem : NSObject {
@protected
    BinaryReader *reader;
    NSUInteger headerSize;
    NSUInteger diskSize;
}

@property (assign) BOOL isValid;
@property (assign) BOOL isBootable;
@property (assign) NSUInteger files;
@property (assign) NSUInteger drives;
@property (assign) NSUInteger sectorSize;
@property (assign) NSUInteger sectorsBoot;
@property (assign) NSUInteger sectorsSystem;
@property (assign) NSUInteger bootAddress;
@property (assign) NSUInteger bootEndAddress;
@property (assign) NSUInteger initAddress;
@property (assign) NSUInteger contAddress;
@property (assign) NSUInteger dosAddress;
@property (assign) NSUInteger sectorMap;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;
@property (retain) NSMutableArray<AtariFile*> *content;
@property (copy) NSString *fileSystem;

- (id)initWithBinaryReader:(BinaryReader*)binaryReaded headerSize:(NSUInteger)header diskSize:(NSUInteger)disk sectorSize:(NSUInteger)sector;

- (BOOL)readBOOT;
- (BOOL)readVTOC;
- (BOOL)readDirectories;
- (NSData *)readBootRecord;
- (NSData *)readSector:(NSUInteger)sector;
- (NSData *)readFile:(NSString *)fileName;

@end

//Supported DOS Versions
//======================
//
//
//DOS2 compatible DOS versions
//============================
//
//Most ATARI DOSes uses DOS2 compatible directory entries and VTOCs. However,
//the VTOC may be placed on different sectors, so original DOS 2 might not be
//able to read files on the disks and vice versa.
//
//DOS2 is "optimized" for serial read/write access und space. It's structure
//is very simple.
//
//
//ATARI DOS 1
//-----------
//
//The first ATARI DOS, shipped with first ATARI 810 disk drives.
//Supported just for completeness. I didn't found any documentation, but
//it seems that is uses the same disk layout as DOS 2.0S except the
//"version 2" flags.
//This DOS supports only Single Density disks (40 tracks, 18 sectors per track,
//                                             128 bytes per sector, FM coding).
//
//Supported Density:    Single
//Supported Functions:    STATFS, READDIR, READ
//
//
//ATARI DOS 2.0S
//--------------
//
//The DOS distributed with later ATARI 810 and early ATARI 1050 disk drives.
//Single Density only. Although the structures are compatible with DOS 1,
//two new flags are used to distinguish from this version.
//
//Supported Density:    Single
//Supported Functions:    STATFS, READDIR, READ
//
//
//ATARI DOS 2.0D
//--------------
//
//A double density version of DOS 2.0S, shipped with the ATARI 815 dual
//disk drive. Supports Double Density disks (40 tracks, 18 sectors per
//                                           track, 256 bytes per sector, MFM coding) only.
//
//Supported Density:    Double
//Supported Functions:    STATFS, READDIR, READ
//
//
//ATARI DOS 2.5
//-------------
//
//The DOS distributed with later ATARI 1050 and earfy XF551 disk drives,
//Single and Medium (Enhanced) density disks (40 tracks, 26 sectors per
//                                            track, 128 bytes per sector, FM coding).
//Single density disks are fully compatible to DOS 2, Medium Disk can be read
//by DOS 2.0.
//The "standard" DOS for 8bit machines.
//
//Supported Density:    Single (== DOS 2.0S), Medium
//Supported Functions:    STATFS, READDIR, READ
//
//
//BiboDOS 5, 6
//------------
//
//Produced by CompyShop this DOS offers 1050 Speedy/Happy/Turbo and
//ATARI XF551 disk drive support.
//Supports all standard densities. DOS 2 compatible directory and VTOC.
//Single and Medium density disks are fully compatible with DOS 2.5.
//
//Supported Density:    Single (== DOS 2.0S), Medium (== DOS 2.5),
//Double (== DOS 2.0D), Quad
//Supported Functions:    STATFS, READDIR, READ
//
//
//MyDOS
//-----
//
//DOS with hard disk and subdirectory support. Extended DOS2 format that
//supports disk images with up to 65535 sectors of 128 or 256 bytes per sector.
//DOS 2 compatible directory and VTOC.
//Source code available.
//Single density disk without subdirectories are fully compatible with DOS 2.
//
//Supported Density:    Single (== DOS 2.0S +SubDirs), Medium, Double, Quad, HD
//Supported Functions:    STATFS, READDIR, READ
//
//
//TopDos
//------
//
//DOS 2 compatible directory and VTOC, but version flag 3.
//
//Supported Density:    Single, Medium, Double, Quad
//Supported Functions:    STATFS, READDIR, READ
//
//
//SmartDOS
//--------
//
//DOS 2 compatible directory and VTOC.
//Single density disks are fully compatible to DOS 2.0S, Double density
//disk to DOS 2.0D.
//
//Supported Density:    Single (== DOS 2.0S), Double (== DOS 2.0D)
//Supported Functions:    STATFS, READDIR, READ
//Note:    cannot be detected because identical formats
//
//
//TurboDOS
//--------
//
//DOS 2 compatible directory and VTOC.
//Single density disks are fully compatible to DOS 2.5, Medium density
//disks to DOS 2.5.
//
//Supported Density:    Single (== DOS 2.0S), Medium (== DOS 2.5),
//Double (== DOS 2.0D), Quad (== MyDOS w/o subdirs)
//Supported Functions:    STATFS, READDIR, READ
//
//
//ATARI DOS 3
//===========
//
//A FAT based dos, distributed with some ATARI 1050 disk drives.
//Supports Single and Medium density disks. Wastes a lot of disk space,
//because the allocation unit is 1k, rarely used.
//
//Supported Density:    Single, Medium
//Supported Functions:    STATFS, READDIR, READ
//
//
//ATARI DOS XE
//============
//
//The last ATARI DOS, shipped with late ATARI XF551 disk drives.
//Supports all standard Densities on ATARI drives.
//FAT based, 256byte allocated unit.
//Sometimes called "ADOS".
//
//Supported Density:    Single, Medium, Double, Quad
//Supported Functions:    currently none
//
//
//ATARI DOS 4 (Antic DOS)
//=======================
//
//This DOS was distributed by ANTIC. Supports the XF551 and non-ATARI diskdrives.
//New densities Double (40 tracks, 26 sectors per track, 256 bytes
//                      per sector, MFM coding) and Quad (40 tracks, 26 sectors per track, 256 bytes
//                                                        per sector, MFM coding, 2 sides).
//FAT based as DOS 3, but with a allocation unit of 768 bytes, rarely used.
//
//Supported Density:    Single, Medium, Double, Quad
//Supported Functions:    STATFS, READDIR, READ
//
//
//SPARTADOS compatible DOSes
//==========================
//
//SPARTADOS
//---------
//
//Not compatible to any other ATARI DOSes this originally ICD produced DOS uses a
//filesystem with sector maps. Supports all densities, hard disks up to
//65525 sectors, 128/256 bytes per sector, subdirectories and creation times.
//SpartaDOS files can be up to 2^24-1 bytes long.
//Its boot mechanism allows to boot any file on the image (as long as this is a
//                                                         bootable image).
//Supports real random access.
//
//Supported Density:    Single, Medium, Double, Quad, HD
//Supported Functions:    STATFS, READDIR, READ
//
//
//BWDos
//-----
//
//A fully compatible SpartaDOS clone. Sourcecode available. Cannot be detected
//due to identical format (will be reported as SpartaDOS 2+)
//
//Supported Density:    Single, Medium, Double, Quad, HD
//Supported Functions:    STATFS, READDIR, READ
//
//
//Special files
//=============
//
//ATR8FS supports several "virtual" files that can be shown in the root
//directory of an Atari disk image:
//
//.boot    This file allows to access the boot sectors of a filesystem
//(All DOSes)
//.vtoc    This file allows to access the DOS2 VTOC (DOS2 compatible
//                                                   DOSes)
//.sfat    This file allows to access to DOS3 FAT (DOS3)
//.s720    This file allows to access sector 720 on DOS2.0 disks (DOS2.0)
//.s1025    This file allows to access sectors 1025 and above on DOS2.5
//disks (DOS2.5)
//.atrhead    This file allows to access the ATR header (ATR images)
//.bootfile    This file is a hard-link to the SpartaDOS boot file
//(SpartaDOS)
//
//Note that these special files cannot be deleted or renamed, neither there length can be changed. The mount option "no_specials" will disable special file support.

