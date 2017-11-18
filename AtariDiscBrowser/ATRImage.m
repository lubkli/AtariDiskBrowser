//
//  ATRFile.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 08/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ATRImage.h"
#import "NSStringExtension.h"

@implementation ATRImage

- (NSInteger)readHeader
{
    NSInteger result;
    @try
    {
        [reader reset];
        
        uint16_t sign = [reader readWord];
        NSLog(@"NICKATARI 0x%04x", sign);
        
        self.diskSize = 0x10 * [reader readWord];
        self.sectorSize = [reader readWord];
        
        uint16_t highSize = [reader readWord];
        NSLog(@"highSize 0x%04x", highSize);
        
        uint8_t diskFlags = [reader readByte];
        NSLog(@"diskFlags 0x%04x", diskFlags);
        
        uint16_t badSect = [reader readWord];
        NSLog(@"badSect 0x%04x", badSect);
        
        for (int i=0; i<5; i++)
            NSLog(@"Z %d", [reader readByte]);
        
        result = 0;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
        result = [reader getOffset];
    }
    return result;
}

- (NSInteger)skipHeader
{
    // skip header
    [reader moveBy:16];
    return 0;
}

@end
