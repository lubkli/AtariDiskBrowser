//
//  HexItem.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 20/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "HexTextLayer.h"
#import "Font.h"

@implementation HexTextLayer

- (void)loadWithData:(NSData *)data atOffset:(NSUInteger)offset {
    charArray = [[NSData alloc] initWithData:data];
    [data enumerateByteRangesUsingBlock:^(const void *bytes,
                                          NSRange byteRange,
                                          BOOL *stop) {
        // Prepare line array of data
        dataArray = [[NSMutableArray<NSString *> alloc] init];
        
        // Header
        NSString *lineString = @"offset 00 01 02 03 04 05 06 07    08 09 0A 0B 0C 0D 0E 0F";
        [dataArray addObject:lineString];
    
        // Data
        NSMutableString *resultAsHexBytes = [NSMutableString string];
        NSUInteger b = 0; // Count space between 8 byte fields and EOL
        NSUInteger r = 0; // Count rows
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
                b++;
                // Append byte in hex
                [resultAsHexBytes appendFormat:@"%02X ", ((uint8_t*)bytes)[i]];

                //Add spaces after 8 byte field
                if (b % 8 == 0) {
                    [resultAsHexBytes appendFormat:@"   "];
                }
                
            if (b == 16)
            {
                //Format whole string and insert into array
                NSString *lineString = [NSString stringWithFormat:@"%06X %@", (unsigned int)(16 * r + offset), resultAsHexBytes];
                [dataArray addObject:lineString];
                resultAsHexBytes = [NSMutableString string];
                b = 0;
                r++;
            }
        }
    }];
    
    [self setNeedsDisplay];
}

- (void) getImage:(CGImageRef *)image forChar:(unsigned char)character {
    int myWidth = 8;
    int myHeight = 8;
    char* rgba = (char*)malloc(myWidth*myHeight*4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int offset=0;
    for(int i=0; i < myHeight; ++i)
    {
        unsigned char ch = FONT[character*8 + i];
        for (int j=myWidth-1; j >= 0; j--)
        {
            int s = 1 << j;
            int b = s & ch;
            char ch2 = b == 0 ? (char)255 : 0;
            
            rgba[4*offset]   = ch2;
            rgba[4*offset+1] = ch2;
            rgba[4*offset+2] = ch2;
            rgba[4*offset+3] = 0;
            offset ++;
        }
    }
    
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       myHeight,
                                                       myWidth,
                                                       8, // bitsPerComponent
                                                       4*myWidth, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast);
    
    *image = CGBitmapContextCreateImage(bitmapContext);
    
    CFRelease(colorSpace);
    free(rgba);
    
    return;
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
    const char* chars = [charArray bytes];
    for (NSString *string in dataArray)
    {
      
        // make the attributed string
        NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attributesDict];
    
        // draw
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
        CGContextSetTextPosition(ctx, 0.0, self.frame.size.height - (i * (12.0 + 2)));
        CTLineDraw(line, ctx);
        
        if (i>1) {
            for (int p=0; p<16; p++) {
                int pos = (i-2)*16 + p;
                
                char ch = chars[pos];
                
                //TODO: prepare chars > 127 at inverse
                if (ch > 127)
                    ch = ch - 127;
                
                // Convert from ATASCII to ASCII
                if (ch < 32)
                    ch += 64;
                else if (ch < 96)
                    ch -= 32;
                
                CGImageRef ir;
                [self getImage:&ir forChar:ch];
                CGContextDrawImage(ctx, CGRectMake(20 * 23.3 + (p*15), self.frame.size.height - (i * (12.0 + 2)) - 3, 14, 14), ir);
            }
        }
        
        i++;
        
        CFRelease(line);
    }
    
    CGContextRestoreGState(ctx);
}

@end
