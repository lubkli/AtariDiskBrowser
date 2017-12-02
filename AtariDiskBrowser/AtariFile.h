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

@property (assign) BOOL OpenForOutput;
@property (assign) BOOL CreatedInDos2;
@property (assign) BOOL Locked;
@property (assign) BOOL EntryInUse;
@property (assign) BOOL Deleted;

@end
