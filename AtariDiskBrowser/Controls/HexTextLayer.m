//
//  HexItem.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "HexTextLayer.h"

@implementation HexTextLayer

- (void)LoadWithData:(NSData *)data {
    [data enumerateByteRangesUsingBlock:^(const void *bytes,
                                          NSRange byteRange,
                                          BOOL *stop) {
        dataArray = [[NSMutableArray<NSString *> alloc] init];
        NSString *lineString = @"     00 01 02 03 04 05 06 07    08 09 0A 0B 0C 0D 0E 0F";
        [dataArray addObject:lineString];
        
//        textArray = [[NSMutableArray<NSString *> alloc] init];
    
        NSMutableString *resultAsHexBytes = [NSMutableString string];
//        NSMutableString *resultAsTextBytes = [NSMutableString string];
        NSUInteger b = 0;
        NSUInteger r = 0;
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
            
            if (b == 16)
            {
                //Format whole string and insert into array
                //NSString *sample = @"0000   96 02 B0 16   80 00 00 00   96 02 B0 16   80 00 00 00   SELECTION CODE X";
                NSString *lineString = [NSString stringWithFormat:@"%04X %@", (unsigned int)(16*r), resultAsHexBytes/*, resultAsTextBytes*/];
                [dataArray addObject:lineString];
                resultAsHexBytes = [NSMutableString string];
//                resultAsTextBytes = [NSMutableString string];
                b = 0;
                r++;
            }
            else
            {
                b++;
                
                //To print raw byte values as hex
                [resultAsHexBytes appendFormat:@"%02X ", ((uint8_t*)bytes)[i]];
                //To print raw byte values
//                [resultAsTextBytes appendFormat:@"%c", ((uint8_t*)bytes)[i]];
                uint8_t u8 = ((uint8_t*)bytes)[i];
                //Add spaces
                if (b % 8 == 0) {
                    [resultAsHexBytes appendFormat:@"   "];
                }
                
            }
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    NSFont *font = [[NSFontManager sharedFontManager]  fontWithFamily:@"Courier" traits:NSFontWeightRegular weight:NSFontWeightRegular size:13];
    CTFontRef sysUIFont = (__bridge CTFontRef)font;
    
    CGColorRef color = [NSColor blackColor].CGColor;
    
    // pack it into attributes dictionary
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)sysUIFont, (id)kCTFontAttributeName,
                                    color, (id)kCTForegroundColorAttributeName,
                                    nil];
    int i = 1;
    for (NSString *string in dataArray)
    {
        // make the attributed string
        NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attributesDict];
    
        // draw
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
        CGContextSetTextPosition(ctx, 10.0, self.frame.size.height - (i * (12.0 + 2)));
        CTLineDraw(line, ctx);
        i++;
        
        CFRelease(line);
    }
    
    // clean up
    //    CFRelease(sysUIFont);
    //    [stringToDraw release];
    
    CGContextRestoreGState(ctx);
}

@end
