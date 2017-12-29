//
//  HexField.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HexField.h"
#import "HexColorLayer.h"
#import "HexTextLayer.h"

@implementation HexField {
    HexColorLayer *_colorLayer;
    HexTextLayer* _textLayer;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        //Add background layer
        _colorLayer = [HexColorLayer layer];
        [self.layer addSublayer:_colorLayer];
        //Add foreground layer
        _textLayer = [HexTextLayer layer];
        [self.layer addSublayer:_textLayer];
        
        [self setLayerFrames];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.wantsLayer = YES;
        //Add background layer
        _colorLayer = [HexColorLayer layer];
        [self.layer addSublayer:_colorLayer];
        //Add foreground layer
        _textLayer = [HexTextLayer layer];
        [self.layer addSublayer:_textLayer];
        
        [self setLayerFrames];
    }
    return self;
}

- (void) setLayerFrames {
    _colorLayer.frame = CGRectInset(self.bounds, 0, 0);
    [_colorLayer setNeedsDisplay];
    
    _textLayer.frame = CGRectInset(self.bounds, 0, 0);
    [_textLayer setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
//        [[NSColor blackColor] set];
//        NSRectFill ( dirtyRect );
}

- (void)loadWithData:(NSData *)data atSector:(NSUInteger)number withSectorSize:(NSUInteger)size {
    _colorLayer.rowCount = size / 16;
    [_textLayer loadWithData:data atOffset:number * size];
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint mouseDownPos = [event locationInWindow];
    mouseDownPos.x -= self.frame.origin.x;
    mouseDownPos.y -= self.frame.origin.y;
    [_colorLayer selectAtPoint:mouseDownPos];
}

@end
