//
//  SectorMap.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 16/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE

//typedef NS_ENUM(NSInteger, SectorStatus) {
//    SectorStatusError = -1,
//    SectorStatusFree = 0,
//    SectorStatusVTOC = 1,
//    SectorStatusDirs = 2,
//    SectorStatusData = 3
//};

@interface SectorMap : NSView {
@private
    NSMutableArray<NSColor*> *colors;
//    SectorStatus *usage;
}

@property (nonatomic, setter=setSectorsCount:) IBInspectable NSUInteger sectorsCount;

@property (nonatomic) IBInspectable NSColor *freeColor;
@property (nonatomic) IBInspectable NSColor *usedColor;

@property (nonatomic) IBInspectable NSUInteger startSelection;
@property (nonatomic) IBInspectable NSUInteger endSelection;
@property (nonatomic) IBInspectable NSColor *selectionColor;

- (void)applyUsage:(const char*)data size:(NSUInteger)length;

@end
