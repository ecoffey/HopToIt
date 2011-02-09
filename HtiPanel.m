//
//  HtiPanel.m
//  HopToIt
//
//  Created by Matthew Henderson on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtiPanel.h"


@implementation HtiPanel
@synthesize inputField, menuletController;

- (void)sendEvent:(NSEvent *)event{
	if ([event type] == NSKeyUp && [event keyCode] == 53) {
		[self toggleVisible];
	}else{
		[super sendEvent:event];
	}
}

- (void) toggleVisible{
	if ([self isVisible]) {
		[inputField setStringValue:@""];
		[menuletController goingHidden];
		[self setIsVisible:NO];

	}else {
		[self setIsVisible:YES];
		[self makeKeyAndOrderFront:nil];
		[[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
	}

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
	if ([[fieldEditor string] length] > 0) {
		[menuletController newEntry:[fieldEditor string]];
		return YES;
	}else{
		return NO;
	}
}

@end
