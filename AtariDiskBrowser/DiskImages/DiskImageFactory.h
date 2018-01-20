//
//  DiskImageFactory.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiskImage.h"

@interface DiskImageFactory : NSObject

+ (DiskImage*)mount:(NSString*)filename;

@end
