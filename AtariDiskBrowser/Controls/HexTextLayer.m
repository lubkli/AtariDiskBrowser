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

- (instancetype)init {
    self = [super init];
    if (self) {
        charSize = 14;
    }
    return self;
}

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
        NSUInteger chars = 0; // Count space between 8 byte fields and EOL
        NSUInteger row = 0; // Count rows
        for (NSUInteger i = 0; i < byteRange.length; ++i) {
                chars++;
                // Append byte in hex
                [resultAsHexBytes appendFormat:@"%02X ", ((uint8_t*)bytes)[i]];

                //Add spaces after 8 byte field
                if (chars % 8 == 0) {
                    [resultAsHexBytes appendFormat:@"   "];
                }
                
            if (chars == 16)
            {
                //Format whole string and insert into array
                NSString *lineString = [NSString stringWithFormat:@"%06X %@", (unsigned int)(16 * row + offset), resultAsHexBytes];
                [dataArray addObject:lineString];
                resultAsHexBytes = [NSMutableString string];
                chars = 0;
                row++;
            }
        }
    }];
    
    [self setNeedsDisplay];
}

- (void) getImage:(CGImageRef *)image forChar:(unsigned char)character inInverse:(bool)inverse {
    // Character size is 8x8
    int width = 8;
    int height = 8;
    // Allocate and fill bitmap array
    unsigned char* rgba = (unsigned char*)malloc(width*height*4);
    int offset=0;
    for(int i=0; i < height; ++i)
    {
        // Get character from font (each byte is binary encoded line)
        unsigned char ch = FONT[character*8 + i];
        for (int j=width-1; j >= 0; j--)
        {
            // Process pixel by pixel in line
            int s = 1 << j;
            bool b = (s & ch) == 0;
            // Invert color when needed
            if (inverse)
                b = !b;
            // Set color in the bitmap array
            unsigned char ch2 = b ? 255 : 0;
            rgba[4*offset]   = ch2;
            rgba[4*offset+1] = ch2;
            rgba[4*offset+2] = ch2;
            rgba[4*offset+3] = 0;
            offset ++;
        }
    }
    
    // Make image from bitmap array
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       height,
                                                       width,
                                                       8, // bitsPerComponent
                                                       4*width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast);
    *image = CGBitmapContextCreateImage(bitmapContext);
    CFRelease(colorSpace);
    free(rgba);
    
    return;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    // Prepare font and color
    NSFont *font = [[NSFontManager sharedFontManager]  fontWithFamily:@"Courier" traits:NSFontWeightRegular weight:NSFontWeightRegular size:13];
    CTFontRef sysUIFont = (__bridge CTFontRef)font;
    CGColorRef color = [NSColor blackColor].CGColor;
    
    // Pack it into attributes dictionary
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)sysUIFont, (id)kCTFontAttributeName,
                                    color, (id)kCTForegroundColorAttributeName,
                                    nil];
    int row = 1;
    const unsigned char* chars = [charArray bytes];
    for (NSString *string in dataArray)
    {
        // Draw hex bytes
        NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attributesDict];
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
        CGContextSetTextPosition(ctx, 0.0, self.frame.size.height - row * charSize);
        CTLineDraw(line, ctx);
        CFRelease(line);
        
        // Draw ATASCII
        if (row>1) {
            for (int p=0; p<16; p++) {
                int pos = (row-2)*16 + p;
                
                unsigned char ch = chars[pos];
                bool isInverse = ch > 127;
                
                // Upper 127 bytes are the same as lower 127 bytes but inverted colors
                if (isInverse)
                    ch = ch - 127;
                
                // Convert from ATASCII to ASCII
                if (ch < 32)
                    ch += 64;
                else if (ch < 96)
                    ch -= 32;
                
                CGImageRef ir;
                [self getImage:&ir forChar:ch inInverse:isInverse];
                CGContextDrawImage(ctx, CGRectMake(20 * 23.3 + (p*15), self.frame.size.height - (row * charSize) - 3, charSize, charSize), ir);
            }
        }
        
        row++;
    }
    
    CGContextRestoreGState(ctx);
}

@end
