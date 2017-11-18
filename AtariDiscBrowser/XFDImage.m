//
//  XFDImage.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "XFDImage.h"

@implementation XFDImage

- (NSInteger)readHeader
{
    NSInteger result;
    @try
    {
        [reader reset];
        
        NSUInteger size = [reader getLength];
        
        switch (size)
        {
            case 92160:
                self.diskSize = 92160;
                break;
                
            case 133120:
                self.diskSize = 133120;
                break;
                
            case 183936:
                self.diskSize = 183936;
                break;
                
            case 184320:
                self.diskSize = 184320;
                break;
                
                default:
                self.diskSize = 0;
                break;
        }
        
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
