//
//  XFDImage.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "XFDImage.h"

@implementation XFDImage

- (NSInteger)readHeader:(BinaryReader *)reader
{
    NSInteger result;
    @try
    {
        [reader reset];
        
        self.diskSize = [reader getLength];
        self.sectorSize = 128;
        
        result = 0;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
        result = [reader getOffset];
    }
    return result;
}

@end
