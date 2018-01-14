//
//  HexLayer.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "HexColorLayer.h"

@implementation HexColorLayer

@synthesize rowCount;

- (instancetype)init {
    self = [super init];
    if (self) {
        xStep = 23.3;
        yStep = 14;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);

    CGRect bounds = CGRectInset(self.frame, 0, 0);
    bounds.origin.x += (2 * xStep) + 4;
    bounds.origin.y += yStep;
    bounds.size.width -= (2 * xStep) + 4;
    bounds.size.height -= yStep;
    
//    CGContextSetFillColorWithColor(ctx, [[NSColor blueColor] CGColor]);
//    CGContextFillRect(ctx, bounds);
    
    NSUInteger position = 0;
    NSUInteger row = 0;
    NSColor *altColor = [NSColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
   
    for (int i = 0; i < self.rowCount; i++)
    {
        if (row > 0) {
            NSColor *color = (row % 2) ? [NSColor whiteColor] : altColor;
            CGContextSetFillColorWithColor(ctx, [color CGColor]);
//            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [NSColor redColor].CGColor);
            CGRect lineFrame = CGRectMake(bounds.origin.x, bounds.size.height - position - 3, 17 * xStep, yStep);
            CGContextFillRect(ctx, lineFrame);
        }
        position += yStep;
        row++;
    }
    
    // Selection
    int16_t xDiff = selectionPoint.x - bounds.origin.x;
    if (xDiff > 0 && selectionPoint.x < 19 * xStep
        && selectionPoint.y < bounds.size.height - 4
        && selectionPoint.y > bounds.size.height - (self.rowCount * yStep) - 2) {
        NSUInteger x = xDiff / xStep;
        if (x != 8) {
            NSUInteger y = selectionPoint.y / yStep;
            // Draw background of selected byte
            CGContextSetFillColorWithColor(ctx, [[NSColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0] CGColor]);
            CGRect selectionFrame = CGRectMake(x * xStep + bounds.origin.x, y * yStep + 1, xStep, yStep);
            CGContextFillRect(ctx, selectionFrame);
            // Draw background of selected column
            selectionFrame = CGRectMake(x * xStep + bounds.origin.x, bounds.size.height - 3, xStep, yStep);
            CGContextFillRect(ctx, selectionFrame);
            // Draw background of selected row
            selectionFrame = CGRectMake(self.frame.origin.x, y * yStep + 1, 2 * xStep, yStep);
            CGContextFillRect(ctx, selectionFrame);
            // Draw background of selected char
            CGContextSetFillColorWithColor(ctx, [[NSColor redColor] CGColor]);
            if (x>8)
                x--;
            selectionFrame = CGRectMake(20 * xStep + x * 14 - 1, y * yStep +1, yStep + 1, yStep + 1);
            CGContextFillRect(ctx, selectionFrame);
        }
    }
    
    // Draw first vertical line
//    CGContextMoveToPoint(ctx, xFirstLine, bounds.origin.y);
//    CGContextAddLineToPoint(ctx, xFirstLine, bounds.size.height + bounds.origin.y);
//    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void)selectAtPoint:(NSPoint)point {
    selectionPoint = point;
    [self setNeedsDisplay];
}

@end
