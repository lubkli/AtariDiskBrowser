//
//  AtariFile.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 11/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtariFile : NSObject {
    uint8_t flags;
    NSUInteger start;
    NSUInteger length;
}

@property (assign) uint8_t flags;
@property (assign) NSUInteger start;
@property (assign) NSUInteger length;
@property (retain) NSString *name;
@property (retain) NSString *ext;

@end
