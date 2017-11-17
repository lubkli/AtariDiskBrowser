//
//  AtariFile.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 11/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtariFile : NSObject

@property (assign) NSUInteger start;
@property (copy) NSString *name;
@property (copy) NSString *ext;
@property (assign) NSUInteger length;
@property (assign) uint8_t flags;


@end

//if ((flags & 0x1) > 0) entry.OpenForOutput = true;
//if ((flags & 0x2) > 0) entry.CreatedInDos2 = true;
//if ((flags & 0x20) > 0) entry.Locked = true;
//if ((flags & 0x40) > 0) entry.EntryInUse = true;
//if ((flags & 0x80) > 0) entry.Deleted = true;

