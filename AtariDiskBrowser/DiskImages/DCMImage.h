//
//  DCMImage.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//
//  Compressed Disk Communicator Image is actually a native Atari file format
//  which contains an entire Atari disk compressed with Bob Puff's Disk
//  Communicator program. Must be decompressed to an ATR before use.

#import "ATRImage.h"

// From: https://www.atarimax.com/freenet/freenet_material/5.8-BitComputersSupportArea/7.TechnicalResourceCenter/showarticle.php?62

//Known bugs and anomalies:

//This specification induces some anomalies.  When the last sector in a
//pass has the flag set that indicates that a sector number must follow
//it, this sector number has no meaning, since the next pass will always
//start out with a sector number.  Diskcomm might not have the next
//sector available.  Therefore, it cannot always determine whether or
//not it is an empty sector.  Since a sector number must be included
//once we set this flag, a fake sector number is appended.  The value
//hex 0045 is used for this.  This is also true for the last pass.  Note
//that this is stored in the low/high byte order.

//Diskcomm processes sectors in chunks of 18 sectors, or chunks of 9
//sectors if the disk is double density.  These chunks might include
//empty sectors.  The last sector in these chunks will always be
//followed by a sector number, since Diskcomm does not read ahead to
//determine the contents of the next sector.  This is not a requirement.
//On creating an archive, Diskcomm just happens to do this.  So a sector
//number might be included even if the next sector is non-zero.

//It looks like Diskcomm has some slight problems.  Double density
//sectors are 256 bytes long.  If the buffer contains hex 5EFF bytes,
//and the sector cannot be compressed, and a sector number must be
//included, we must add 259 bytes to the buffer.  To mark the end of
//pass, we have to add either one hex 45 byte, or hex 45 00 45.  This
//might add up to three extra bytes.  The pass would be hex 6003 bytes
//long.  This makes the pass longer than hex 6002 bytes.  On reading,
//this is also a problem.  Diskcomm will not store the first two bytes,
//since the two header bytes are read and processed first.  Then it
//tries to read hex 6000 bytes.  Within these hex 6000 bytes, the end of
//pass code must be included.  This will be missing though, so Diskcomm
//will not be able to process the file.  This problem only occurs with
//double density disks in the specified exceptional conditions.

//When a pass contains exactly hex 6002 bytes, Diskcomm will terminate
//processing after this pass.  Therefore, passes should be less than hex
//6002 in length.  This can only occur with archives of double density
//disks.

//For unknown reasons, the passes above pass number 31 have their pass
//number reduced by one.  Only the five low order bits are stored.

//For multi-file archives, a selected character of the filename is
//incremented for each pass.  This will eventually cause an invalid
//character to be used in the filename, depending on the restrictions
//imposed by the DOS used.

typedef struct {
    int sectorcount;
    int current_sector;
} SECTOR_Info;

@interface DCMImage : ATRImage {
    uint8_t archive_type;
    uint8_t archive_flags;
}

- (NSData *)decode:(NSData *)data;

- (BOOL)padTillSector:(int)sectorNumber withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target;
- (BOOL)decodeSectors:(BinaryReader *)source withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target;
- (BOOL)decodePass:(BinaryReader *)source withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target;

@end
