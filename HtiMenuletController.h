//
//  HtiMenuletController.h
//  HopToIt
//
//  Created by Matthew Henderson on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class HtiPanel, HtiTimeTracker, HtiTimeEntry;

enum TableState{None,Recent,TodayList, TotalSum};

@interface HtiMenuletController : NSResponder <NSCollectionViewDelegate, NSTableViewDataSource>{
	HtiPanel *panel;
	NSMenu* menu;
	NSImage* statusImage;
	NSStatusItem* statusItem;
	HtiTimeTracker* timeTracker;
	NSScrollView* scrollView;
	NSTableView* table;
	enum TableState currentTableState;
}
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData);
@property (assign) IBOutlet HtiPanel *panel;
@property (assign) IBOutlet NSMenu* menu;
@property (assign) IBOutlet NSScrollView* scrollView;
@property (assign) IBOutlet NSTableView* table;
@property (assign) HtiTimeTracker* timeTracker;
- (IBAction) quit:(id)sender;
- (IBAction) quit:(id)sender;
- (IBAction) hopToItMenuletAction:(id)sender;
- (void) newEntry:(NSString*)entry;
- (void) toggleTable;
- (void) goingHidden;

@end
