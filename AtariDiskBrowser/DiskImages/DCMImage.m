//
//  DCMImage.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "DCMImage.h"
#import "BinaryReader.h"

@implementation DCMImage

//Diskcomm archive: A Diskcomm archive consists of one or more passes.
//When an archive is split into multiple files, each pass is stored in a
//separate file.
//Pass: A pass consists of an archive type code, followed by pass
//information, followed by the starting sector number, followed by one
//or more sector data packets, followed by the end of pass code.
//Archive type: The archive type indicates whether this is a multi file
//archive (F9) or not (FA).
- (NSData *)decode:(NSData *)data {
    uint8_t lastSector;
    SECTOR_Info sectorInfo;
    
    BinaryReader *source = [BinaryReader binaryReaderWithData:data littleEndian:YES];
    NSMutableData *output = [[NSMutableData alloc] init];
    
    archive_type = [source readByte];
    if (archive_type != 0xf9 && archive_type != 0xfa)
        return nil;
    
    archive_flags = [source readByte];
    if ((archive_flags & 0x1f) != 1)
        return nil;
    
    sectorInfo.current_sector = 1;
    
    switch ((archive_flags >> 5) & 3) {
        case 0:
            sectorInfo.sectorcount = 720;
            _sectorSize = 128;
            break;
        case 1:
            sectorInfo.sectorcount = 720;
            _sectorSize = 256;
            break;
        case 2:
            sectorInfo.sectorcount = 1040;
            _sectorSize = 128;
            break;
        default: // Unrecognized density
            return nil;
    }
    
    [self makeHeaderWithSectorSize:_sectorSize andSectorCount:sectorInfo.sectorcount];
    [output appendBytes:&header length:sizeof(header)];
    
    if (![self decodePass:source withInfo:&sectorInfo to:output])
        return nil;
    
    lastSector = sectorInfo.current_sector - 1;
    if (lastSector <= sectorInfo.sectorcount)
        if (![self padTillSector:sectorInfo.sectorcount + 1 withInfo:&sectorInfo to:output])
            return nil;
    
    return [NSData dataWithData:output];
}

- (BOOL)padTillSector:(int)sectorNumber withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target {
    uint8_t zero_buf[256];
    memset(zero_buf, 0, sizeof(zero_buf));
    while (sectorInfo->current_sector < sectorNumber)
        [target appendBytes:zero_buf length:sectorInfo->current_sector++ <= 3 ? 128 : _sectorSize];
    return YES;
}

//Sector number: An unsigned sector number, which is two bytes.  The
//first byte is the low order portion of the number, the second byte is
//the high order portion of the number.  Normally ranging from 1 to 9999
//decimal.
//Pass number: A sequence number assigned to each pass.  Normally
//ranging from 1 to 31 decimal.  This might roll over to zero after 31.
//End of pass: The value hex 45.
//Compression type: One of the following hex values: 41, 42, 43, 44, 46
//or 47.  The meaning of these values is described below.
- (BOOL)decodeSectors:(BinaryReader *)source withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target {
    //The buffer that holds the contents of the previous non-zero sector is
    //initialized at the start of a pass if the archive is a multi file
    //archive.  For single file archives, this buffer is cleared at the
    //start of the first pass only.
    uint8_t sectorBuffer[256];
    memset(sectorBuffer, 0, sizeof(sectorBuffer));
    
    for (;;) {
        NSData *data;
        
        int sectorNumber = [source readWord];
        
        int sectorType = [source readByte];
        //This compression type indicates the end of a pass, so it is not a real
        //compression type.  There is no sector data for this type.  For a multi
        //file archive, this indicates the end of the file.  The archive is
        //continued in the next file, unless this pass was the last pass.  For
        //single file archives, this indicates that the next pass follows within
        //this file, unless this was the last pass.  The next pass starts with a
        //header again, followed by a sector number.
        if (sectorType == 0x45)
            return YES;
        
        if (sectorNumber < sectorInfo->current_sector)
            return NO;
        
        if (![self padTillSector:sectorNumber withInfo:sectorInfo to:target])
            return NO;
        
        // sector
        for (;;) {
            uint8_t i;
            switch (sectorType & 0x7f) {
                case 0x41:
                    //The compression is relative to the previous sector.  The sector data
                    //contains only the beginning portion.  The last portion is not changed.
                    //The first byte of the sector data specifies at what offset to start
                    //modifying the sector.  The remaining bytes of the sector data are used
                    //to modify the beginning portion of the sector.  This modification
                    //takes place starting at the byte at the start offset, working towards
                    //the beginning of the sector, up to and including the byte at offset
                    //zero, the first byte of the sector.  This implies that the data bytes
                    //are stored in a reverse order in the sector data.
                    if ([source isEOF])
                        return NO;
                    i = [source readByte];
                    do {
                        if ([source isEOF])
                            return NO;
                        sectorBuffer[i] = [source readByte];
                    } while (i-- != 0);
                    break;
                    
                case 0x42:
                    //This is an obsolete compression type, that was used by early versions
                    //of Diskcomm.  Earlier versions of Diskcomm supported only single
                    //density diskettes, so this type of sector always represents 128 bytes.
                    //Programs that decode archives should be aware of this.  Using it for
                    //creating new archives is not recommended.  The sector data contains
                    //five bytes.  The first byte of the sector data is used to initialize
                    //the first 124 bytes of the sector.  The remaining four bytes are
                    //stored in the last four bytes of the sector.
                    data = [source readData:5];
                    [data getBytes:(sectorBuffer + 123) range:NSMakeRange(0, data.length - 1)];
                    memset(sectorBuffer, sectorBuffer[123], 123);
                    break;
                    
                case 0x43:
                    //The sector data contains substrings.  These substrings alternate
                    //between uncompressed and compressed, starting with an uncompressed
                    //substring.  Each of these substrings starts with a byte that specifies
                    //the ending offset of the resulting data in the sector.  When this
                    //ending offset position is reached, the end of the substring is
                    //reached, and the byte at this ending offset is the starting position
                    //for the next substring.  The starting position for the first substring
                    //is at offset zero.  An uncompressed substring will contain as many
                    //bytes as are needed to fill the sector from the start position up to,
                    //but not including the end offset.  For uncompressed substrings, if the
                    //starting position offset is equal to the ending offset, there is no
                    //further data, so in effect, this is a null string.  This is used when
                    //there are two portions of data within the sector that can be
                    //compressed, without other data in between these portions.  The
                    //uncompressed substring must be present, therefore a null string must
                    //be used in this case.  Compressed substrings are always two bytes in
                    //length.  The compressed substring starts with a byte that indicates
                    //the ending offset.  The second byte contains the fill character.  The
                    //portion of the sector starting at the start offset, up to, but not
                    //including the ending offset, is set to the value of this fill
                    //character.  After the compressed substring, another uncompressed
                    //substring follows.
                    //For double density disks, the ending offset for the last substring is
                    //256.  Since there is only one byte to represent the ending offset,
                    //this is stored as zero.  However, zero is an offset that can be used
                    //for the first uncompressed string, to indicate that the first
                    //uncompressed string is a null string.  The end of this type of
                    //compressed sector is reached when all bytes in the sector have been
                    //processed.  This can occur at the end of an uncompressed substring.
                    //In this case, there will not be a compressed substring following the
                    //uncompressed string.  Likewise, if it occurs at the end of a
                    //compressed substring, there will not be an uncompressed string
                    i = 0;
                    do {
                        uint8_t j;
                        int c;
                        j = [source readByte];
                        if (j < i) {
                            if (j != 0)
                                return NO;
                            j = (unsigned char)256;
                        }
                        if (i < j) {
                            data = [source readData:j - i];
                            [data getBytes:(sectorBuffer + i) range:NSMakeRange(0, data.length - 1)];
                        }
                        if (j >= _sectorSize)
                            break;
                        i = [source readByte];
                        if (i < j) {
                            if (i != 0)
                                return NO;
                            i = (unsigned char)256;
                        }
                        if ([source isEOF])
                            return NO;
                        c = [source readByte];
                        memset(sectorBuffer + j, c, i - j);
                    } while (i < _sectorSize);
                    break;
                    
                case 0x44:
                    //The compression is relative to the previous sector.  The sector data
                    //contains only the ending portion.  The beginning portion is not
                    //changed.  The first byte of the sector data specifies at what offset
                    //to start modifying the sector.  The remaining bytes of the sector data
                    //are used to modify the ending portion of the sector.  This
                    //modification takes place starting at the byte at the start offset, up
                    //to, and including the last byte of the sector.
                    if ([source isEOF])
                        return NO;
                    i = [source readByte];
                    if (i >= _sectorSize)
                        return NO;
                    data = [source readData:_sectorSize - i];
                    [data getBytes:sectorBuffer + i range:NSMakeRange(0, data.length - 1)];
                    break;
                    
                case 0x46:
                    //This compression type indicates that the data for this sector is
                    //identical to the data of the previous non-zero sector.  There is no
                    //sector data for this type.
                    break;
                    
                case 0x47:
                    //The sector data contains the number of bytes required to fill an
                    //entire sector, either 128 or 256 bytes.  No compression of any kind is
                    //performed on this sector type.
                    data = [source readData:_sectorSize];
                    [data getBytes:sectorBuffer range:NSMakeRange(0, data.length - 1)];
                    break;
                    
                default: // Unrecognized sector coding type 0x%02X
                    return NO;
            }
            
            [target appendBytes:sectorBuffer length:sectorInfo->current_sector++ <= 3 ? 128 : _sectorSize];
            
            if (!(sectorType & 0x80)) // goto sector group
                break;
            
            sectorType = [source readByte];
            if (sectorType == 0x45)
                return YES;
        }
    }
}

//Sector data: A sector data packet consists of one byte that indicates
//the content type for the sector data packet.  After the content type,
//the compressed data for the sector follows.  The contents of this
//depends on the type of compression, and it can contain any number of
//bytes, from zero up to the length of the sector for the type of disk,
//either 128 or 256 bytes.  The high order bit of the content type is
//used to indicate whether or not a sector number will follow the
//compressed data.  If this bit is zero, a sector number will follow the
//data.  If this bit is one, there will not be a sector number following
//the compressed data.
//Sequential flag: This flag indicates whether or not the sector packet
//contains a sector number.  If this flag has the value 00, a sector
//number will follow the sector data.  If it has the value 80, there
//will not be a sector number following the sector data, and the next
//sector is the next sequential sector.
//Content type: The high order bit of this byte is the sequential flag.
//The remaining low order bits are the compression type.
- (BOOL)decodePass:(BinaryReader *)source withInfo:(SECTOR_Info *)sectorInfo to:(NSMutableData *)target {
    uint8_t passFlags = archive_flags;
    
    for (;;) {
        int blockType;
        
        if (![self decodeSectors:source withInfo:sectorInfo to:target])
            return NO;
        
        if (passFlags & 0x80)
            break;
        
        blockType = [source readByte];
        if (blockType != archive_type) {
            if (blockType == EOF && archive_type == 0xf9) {
                // TODO: Multi-part archive error.{
            }
            return NO;
        }
        
        passFlags = [source readByte];
        if ((passFlags ^ archive_flags) & 0x60)
            return NO;
    }
    return YES;
}

@end

