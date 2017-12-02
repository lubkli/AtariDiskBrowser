//
//  XFDImage.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "XFDImage.h"

@implementation XFDImage

- (id)init
{
    self = [super init];
    if (self)
    {
        _headerSize = 0;
    }
    return self;
}

- (BOOL)readHeader
{
    BOOL result;
    @try
    {
        [reader reset];
        
        NSUInteger size = [reader getLength];
        
        switch (size)
        {
            case 92160:
                _diskSize = 92160;
                _sectorSize = 128;
                break;
                
            case 133120:
                _diskSize = 133120;
                _sectorSize = 128;
                break;
                
            case 183936:
                _diskSize = 183936;
                _sectorSize = 128;
                break;
                
            case 184320:
                _diskSize = 184320;
                _sectorSize = 128;
                break;
                
                default:
                _diskSize = 0;
                break;
        }
        
        result = YES;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
//        result = [reader getOffset];
    }
    return result;
}

@end
