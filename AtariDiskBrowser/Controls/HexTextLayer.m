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
        stringArray = [[NSMutableArray<NSString *> alloc] init];
        NSMutableString *resultAsHexBytes = [NSMutableString string];
        NSMutableString *resultAsTextBytes = [NSMutableString string];
        NSUInteger b = 0;
        NSUInteger r = 0;
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
            
            if (b == 16)
            {
                //Format whole string and insert into array
                //NSString *sample = @"0000   96 02 B0 16   80 00 00 00   96 02 B0 16   80 00 00 00   SELECTION CODE X";
                NSString *lineString = [NSString stringWithFormat:@"%04lu  %@%@", (unsigned long)(16*r), resultAsHexBytes, resultAsTextBytes];
                [stringArray addObject:lineString];
                resultAsHexBytes = [NSMutableString string];
                resultAsTextBytes = [NSMutableString string];
                b = 0;
                r++;
            }
            else
            {
                b++;
                
                //To print raw byte values as hex
                [resultAsHexBytes appendFormat:@"%02X ", ((uint8_t*)bytes)[i]];
                //To print raw byte values
                [resultAsTextBytes appendFormat:@"%c", ((uint8_t*)bytes)[i]];
                //Add spaces
                if (b % 4 == 0) {
//                    [resultAsHexBytes appendFormat:@"  "];
                    [resultAsTextBytes appendFormat:@"#"]; // TODO: convert atascii 2 ascii
                }
                
            }
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    // create a font, quasi systemFontWithSize:24.0
    //    CTFontRef sysUIFont = CTFontCreateUIFontForLanguage(kCTFontSystemFontType, 12.0, NULL);
    //    NSFont *font = [NSFont monospacedDigitSystemFontOfSize:12 weight:NSFontWeightRegular];
    NSFont *font = [[NSFontManager sharedFontManager]  fontWithFamily:@"Courier" traits:NSFontWeightRegular weight:NSFontWeightRegular size:12];
    CTFontRef sysUIFont = (__bridge CTFontRef)font;
    //    UIFont.monospacedDigitSystemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightRegular)
    
    // blue
    CGColorRef color = [NSColor blackColor].CGColor;
    
    // single underline
    // NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleSingle];
    
    // pack it into attributes dictionary
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)sysUIFont, (id)kCTFontAttributeName,
                                    color, (id)kCTForegroundColorAttributeName,
                                    nil];
    //                                    underline, (id)kCTUnderlineStyleAttributeName, nil];
    int i = 1;
    for (NSString *string in stringArray)
    {
        // make the attributed string
        NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attributesDict];
        
        // flip the coordinate system
        //    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
        //    CGContextTranslateCTM(ctx, 0, self.bounds.size.height/2);
        //    CGContextScaleCTM(ctx, 1.0, 1.0);
        
        // draw
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
        //    int i = self.frame.size.height;
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
