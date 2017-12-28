//
//  HexLayer.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "HexLayer.h"

@implementation HexLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        xFirstLine = 45;
        xSecondLine = 445;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);

    CGRect bounds = CGRectInset(self.frame, 0, 3);
    
    CGContextSetFillColorWithColor(ctx, [[NSColor whiteColor] CGColor]);
    CGContextFillRect(ctx, bounds);
    
    NSUInteger position = 0;
    NSUInteger step = 14;
    NSUInteger row = 0;
    NSColor *altColor = [NSColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    while (position < self.frame.size.height)
    {
        if (row > 0) {
            NSColor *color = (row % 2) ? [NSColor whiteColor] : altColor;
            
            CGContextSetFillColorWithColor(ctx, [color CGColor]);
            
//            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [NSColor redColor].CGColor);
            
            CGRect lineFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y + (self.frame.size.height - position - 3), self.frame.size.width, step);
            CGContextFillRect(ctx, lineFrame);
        }
        position += step;
        row++;
    }
    
    // Selection
    int16_t xDiff = selectionPoint.x - xFirstLine;
    if (xDiff > 0 && selectionPoint.y != 0) {
        NSUInteger x = xDiff / 21.6;
        NSUInteger y = selectionPoint.y / step;
        
        CGContextSetFillColorWithColor(ctx, [[NSColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0] CGColor]);
//        CGRect selectionFrame = CGRectMake(x * 21.6 + xFirstLine + 8, self.frame.origin.y + (y * step) - 4, 15, step);
        CGRect selectionFrame = CGRectMake(x * 21.6 + xFirstLine + 8 - 5, self.frame.origin.y + (y * step) - 4, 25, step);
        CGContextFillRect(ctx, selectionFrame);
    }
    
    // Draw first vertical line
    CGContextMoveToPoint(ctx, xFirstLine, bounds.origin.y);
    CGContextAddLineToPoint(ctx, xFirstLine, bounds.size.height + bounds.origin.y);
    CGContextStrokePath(ctx);
    
    // Draw first vertical line
    CGContextMoveToPoint(ctx, xSecondLine, bounds.origin.y);
    CGContextAddLineToPoint(ctx, xSecondLine, bounds.size.height + bounds.origin.y);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void)selectAtPoint:(NSPoint)point {
    selectionPoint = point;
    [self setNeedsDisplay];
}

@end
