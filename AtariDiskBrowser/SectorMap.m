//
//  SectorMap.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 16/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "SectorMap.h"

@implementation SectorMap

@synthesize sectorsCount = _sectorsCount;

@synthesize freeColor;
@synthesize usedColor;

@synthesize startSelection;
@synthesize endSelection;
@synthesize selectionColor;

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionColor = [NSColor alternateSelectedControlColor];
        self.freeColor      = [NSColor colorWithRed:0.389 green:0.855 blue:0.22 alpha:0.5];
        self.usedColor      = [NSColor colorWithRed:0 green:0.6 blue:0 alpha:1];
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionColor = [NSColor alternateSelectedControlColor];
        self.freeColor      = [NSColor colorWithRed:0.389 green:0.855 blue:0.22 alpha:0.5];
        self.usedColor      = [NSColor colorWithRed:0 green:0.6 blue:0 alpha:1];
        [self customInit];
    }
    return self;
}

- (void)setSectorsCount:(NSUInteger)sectorsCount
{
    _sectorsCount = sectorsCount;
    colors = [NSMutableArray<NSColor*> arrayWithCapacity:_sectorsCount+1];
    for (int i=0; i<_sectorsCount+1; i++)
    {
        if ((i >= 0) && (i < 3 ))
            colors[i] = [NSColor orangeColor];
        else if (i == 359)
            colors[i] = [NSColor lightGrayColor];
        else if ((i >= 360) && (i < 368 ))
            colors[i] = [NSColor darkGrayColor];
//        else if ((i >= self.startSelection) && (i < self.endSelection ))
//            colors[i] = self.selectionColor;
        else colors[i] = [NSColor grayColor];
    }

}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    [self customInit];
}

- (void)prepareForInterfaceBuilder {
    [self customInit];
}

- (void)customInit {
    if (self.sectorsCount==0)
        return;
    
    // Drawing code here.
    int hc = 32;
    CGFloat width = self.frame.size.width;
    int hs = width / hc;
    int newWidh = hs * hc;
    int diffWidth = width - newWidh;

    NSRect  newBounds  = NSMakeRect(diffWidth / 2 - 2, 0, newWidh + 3, self.frame.size.height);
    
    // setup basics
//    [[NSColor blackColor] set];
//    NSRectFill ( newBounds );
    
//    [[NSColor lightGrayColor] set];
//    NSFrameRectWithWidth( newBounds, 1);
    
    NSUInteger count = self.sectorsCount;
    NSRect startingRect = NSMakeRect ( newBounds.origin.x + 1, newBounds.size.height - 8, hs + 1, 8 );
    
    // create arrays of rects and colors
    NSRect    rectArray [count];
    NSColor * colorArray[count];
    rectArray [0] = startingRect;
    colorArray[0] = [NSColor orangeColor];
    
    // populate position array
    int i;
    int row = 1;
    NSRect oneRect = rectArray[0];
    for (i = 1; i < count; i++ )
    {
        oneRect.origin.x += hs;
        
        if (i >= (row * hc))
        {
            row++;
            oneRect.origin.x = startingRect.origin.x;
            oneRect.origin.y -= 7;
        }
        
        rectArray [i] = oneRect;
    }
    
    // prepare for drawing of selected sectors
    for (int i=0; i<count; i++)
    {
        if ((i >= self.startSelection) && (i < self.endSelection ))
            colorArray[i] = self.selectionColor;
        else
            colorArray[i] = colors[i+1];
    }
    
    // use rect and color arrays to fill
    NSRectFillListWithColors ( rectArray, colorArray, count );
    
    // draw a 1 pixel border around each rect
    [[NSColor blackColor] set];
    for ( i = 0; i < count; i++) {
        NSFrameRectWithWidth ( rectArray[i], 1 );
    }
}

-(void)fixUsage
{
    for (int i=0; i<self.sectorsCount; i++)
    {
        if ((i >= 0) && (i <= 3 ))
            colors[i] = [NSColor redColor];
        else if (i == 360)
            colors[i] = [NSColor blueColor];
        else if ((i >= 361) && (i <= 368 ))
            colors[i] = [NSColor systemBlueColor];
    }
    
    colors[_sectorsCount] = [NSColor blackColor];
}

- (void)applyUsage:(const char*)data size:(NSUInteger)length
{
    int c = 0;
    // enumerate bytes
    for (int i=0; i<length; i++)
    {
        char ch = data[i];
        // enumerate bits
        for (int j=0; j<8; j++)
        {
            if ((ch & 0x80) > 0)
            { // bit 1 => available sector
                colors[c] = self.freeColor;
            }
            else
            { // bit 0 => used sector
                colors[c] = self.usedColor;
            }
            
            c++;
            ch = (ch << 1);
        }
    }
    
    [self fixUsage];
}

@end
