//
//  HexLayer.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface HexColorLayer : CALayer {
    double xStep;
    double yStep;
    NSPoint selectionPoint;
}

@property (assign) NSUInteger rowCount;

- (void)selectAtPoint:(NSPoint)point;

@end
