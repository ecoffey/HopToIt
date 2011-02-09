//
//  HtiMenuletController.m
//  HopToIt
//
//  Created by Matthew Henderson on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtiMenuletController.h"
#import "HtiPanel.h"
#import "HtiTimeTracker.h"
#import "HtiTimeEntry.h"

#define kTableSize 210

@implementation HtiMenuletController
@synthesize menu, panel, timeTracker, scrollView;
void* menulet;

- (void) awakeFromNib
{	
	NSBundle *bundle = [NSBundle mainBundle];

	// Insert code here to initialize your application 
	//Register the Hotkeys
	EventHotKeyRef gMyHotKeyRef;
	EventHotKeyID gMyHotKeyID;
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,NULL,NULL);
	// Create Hotkey 1, command+option+space
	gMyHotKeyID.signature='htk1';
	gMyHotKeyID.id=1;
	RegisterEventHotKey(49, cmdKey+shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	
	// Create Hotkey 2, command+option+right arrow
	gMyHotKeyID.signature='htk2';
	gMyHotKeyID.id=2;
	RegisterEventHotKey(124, cmdKey+optionKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"hop3" ofType:@"png"]];
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setImage:statusImage];
	[statusItem setHighlightMode:YES];
	
	//[menu setAutoenablesItems:NO];
	
	[statusItem setMenu:menu];
	[statusItem setToolTip:@"Hop To It"];
	[statusItem setAction:@selector(hopToItMenuletAction:)];
	menulet = self;
	timeTracker = [[HtiTimeTracker alloc] init];
	[timeTracker reload];
	currentTableState = None;
	[self toggleTable];
}

- (void) toggleHud{
	[panel toggleVisible];
	
}

- (void) toggleTable{
	CGRect tempFrame = panel.frame;
	switch (currentTableState) {
		case None:
			if(![scrollView isHidden]){
				[scrollView setHidden:YES];
				NSLog(@"%f %f %f %f", tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
				tempFrame.size.height = 109;
				tempFrame.origin.y += kTableSize;
				[panel setFrame:tempFrame display:YES];
			}
			break;
		case Recent:
		case TodayList:
		case TotalSum:
			if([scrollView isHidden]){
				[scrollView setHidden:NO];
				NSLog(@"%f %f %f %f", tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
				tempFrame.size.height = 315;
				tempFrame.origin.y -= kTableSize;
				[panel setFrame:tempFrame display:YES]; 
			}
			break;
		default:
			break;
	}
}

static void toggleHudWrapper(void* menuletCtrl){
	id hmc = (id) menuletCtrl;
	NSLog(@"toggleHudWrapper %@", menuletCtrl);
	[hmc toggleHud];
}

- (void) goingHidden{
	currentTableState = None;
	[self toggleTable];
}



OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData)
{
	EventHotKeyID hkCom;
	GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL, sizeof(hkCom),NULL,&hkCom);
	int l = hkCom.id;
	
	switch (l) {
		case 1: //do something
			NSLog (@"HOTKEY 1 PRESSED");
			break;
		case 2: //do something
			NSLog (@"HOTKEY 2 PRESSED");
			break;
	}
	toggleHudWrapper(menulet);
	return noErr;
}

- (BOOL)windowShouldClose:(id)sender{
	NSLog(@"windowShouldClose");
	return YES;
}


-(IBAction)hopToItMenuletAction:(id)sender
{
	NSLog(@"hopToItMenuletAction");
	[self toggleHud];
}

- (void) newEntry:(NSString*)entry{
	if ([entry characterAtIndex:0] == ':') {
		NSString* command = [entry substringFromIndex:1];
		if ([command isCaseInsensitiveLike:@"stop"]) {
			NSLog(@"stop");
			[timeTracker stopCurrentEntry];
			[self toggleHud];
		}else if ([command isCaseInsensitiveLike:@"list"]) {
			NSLog(@"list");
			currentTableState = TodayList;
			[timeTracker todaysEntries];
			[self toggleTable];
			[table reloadData];
		}
	}else{
		[timeTracker newEntry:entry];	
		[self toggleHud];
	}
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	switch (currentTableState) {
		case None:
			return 0;
		case Recent:
			return [[timeTracker recentEntries] count];
		case TodayList:
			return [[timeTracker todaysEntries] count];
		case TotalSum:
			return 1;
		default:
			break;
	}
    return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	
    switch (currentTableState) {
		case None:
			return 0;
		case Recent:
			return [[[timeTracker recentEntries] objectAtIndex:rowIndex] summary];
		case TodayList:
			return [[[timeTracker todaysEntries] objectAtIndex:rowIndex] summary];
		case TotalSum:
			return @"total";
		default:
			break;
	}
    return @"";
}


#pragma mark -
#pragma mark Messages Delegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 40;
}

- (IBAction) quit:(id)sender
{
	exit(0);
}

@end
