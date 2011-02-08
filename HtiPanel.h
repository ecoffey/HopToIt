//
//  HtiPanel.h
//  HopToIt
//
//  Created by Matthew Henderson on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HtiMenuletController.h"

@interface HtiPanel : NSPanel <NSTextFieldDelegate>{
	NSTextField* inputField;
	HtiMenuletController* menuletController;
}
@property (assign) IBOutlet NSTextField* inputField;
@property (assign) IBOutlet HtiMenuletController* menuletController;

- (void) toggleVisible;

@end
