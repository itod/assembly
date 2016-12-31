//
//  ASMemoryViewController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMemoryViewController.h"
#import "ASMemoryHeaderListItem.h"
#import "ASMemoryLocationListItem.h"

#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASRegister.h>

#define MAX_DWORD 0xFFFFFFFF

#define NUM_ITEMS (0xFF + 3)

@interface ASMemoryViewController ()
@property (nonatomic, retain) ASContext *context;
@end

@implementation ASMemoryViewController

- (id)init {
    self = [super initWithNibName:@"ASMemoryViewController" bundle:nil];
    return self;
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    TDAssertMainThread();

    self.scrollView = nil;
    self.listView = nil;
    self.context = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    TDAssertMainThread();

    [super viewDidLoad];
    
    self.viewControllerView.color = [NSColor windowBackgroundColor];
    
    _listView.displaysClippedItems = YES;
    _listView.backgroundColor = [NSColor windowBackgroundColor];
    
    _scrollView.frame = [self.viewControllerView bounds];
    [_listView reloadData];
}


- (void)renderWithContext:(ASContext *)ctx {
    TDAssertMainThread();
    
    self.context = ctx;
    [_listView reloadData];
}


#pragma mark -
#pragma mark TDListViewDataSource

- (NSUInteger)numberOfItemsInListView:(TDListView *)lv {
    return NUM_ITEMS;
}


- (TDListItem *)listView:(TDListView *)lv itemAtIndex:(NSUInteger)i {
    NSParameterAssert(i < MAX_DWORD);
    NSAssert(_context, @"");

    ASDword idx = (ASDword)i;
    
    TDListItem *result = nil;
    
    if (0 == idx || NUM_ITEMS - 1 == i) {
        result = (id)[_listView dequeueReusableItemWithIdentifier:[ASMemoryHeaderListItem identifier]];
        
        if (!result) {
            result = [[[ASMemoryHeaderListItem alloc] init] autorelease];
        }        
    } else {
        ASMemoryLocationListItem *item = (id)[_listView dequeueReusableItemWithIdentifier:[ASMemoryLocationListItem identifier]];
        
        if (!item) {
            item = [[[ASMemoryLocationListItem alloc] init] autorelease];
            item.context = _context;
        }

        ASDword addr = MAX_DWORD - (idx - 1);
        item.address = addr;
        
        ASDword spAddr = _context.esp.dwordValue;
        item.isStackPointer = addr == spAddr;
        item.isBelowStackPointer = (addr != MAX_DWORD && addr + 1 == spAddr);
        item.isLast = NUM_ITEMS - 2 == i;
        item.isDwordBoundary = 0 == ((addr + 1)  % 4);
        result = item;
    }
    
    [result setNeedsDisplay:YES];
    
    return result;
}


#pragma mark -
#pragma mark TDListViewDelegate

- (CGFloat)listView:(TDListView *)lv extentForItemAtIndex:(NSUInteger)i {
    CGFloat h = 0.0;
    
    if (0 == i || NUM_ITEMS - 1 == i) {
        h = [ASMemoryHeaderListItem defaultHeight];
    } else {
        h = [ASMemoryLocationListItem defaultHeight];
    }
    
    return h;
}

@end
