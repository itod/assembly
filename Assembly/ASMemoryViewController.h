//
//  ASMemoryViewController.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDAppKit.h>

@class ASContext;

@interface ASMemoryViewController : TDViewController <TDListViewDataSource, TDListViewDelegate>

- (void)renderWithContext:(ASContext *)ctx;

@property (nonatomic, retain) IBOutlet NSScrollView *scrollView;
@property (nonatomic, retain) IBOutlet TDListView *listView;
@end