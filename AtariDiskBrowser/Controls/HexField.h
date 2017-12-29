//
//  HexField.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HexField : NSControl 

- (void)loadWithData:(NSData *)data atSector:(NSUInteger)number withSectorSize:(NSUInteger)size;

@end
