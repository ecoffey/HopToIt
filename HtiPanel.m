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
	//
}

- (void) toggleVisible{
	if ([self isVisible]) {
		[menuletController goingHidden];
		[self setIsVisible:NO];

	}else {
		[self setIsVisible:YES];
		[inputField setStringValue:@""];
		[self makeFirstResponder: inputField];
	}

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
	NSLog(@"textShouldEndEditing %@", [fieldEditor string]);
	[menuletController newEntry:[fieldEditor string]];
	//[self toggleVisible];
	return YES;
}

@end
