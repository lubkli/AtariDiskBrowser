//
//  HexItem.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface HexTextLayer : CALayer {
    NSMutableArray<NSString*> *stringArray;
}

- (void)LoadWithData:(NSData *)data;

@end
