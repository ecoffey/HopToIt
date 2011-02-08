//
//  HtiTimeTracker.h
//  HopToIt
//
//  Created by Matthew Henderson on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HtiTimeEntry;
@interface HtiTimeTracker : NSObject {
	NSMutableArray* _todaysEntries;
	NSMutableArray* _recentEntries;
	HtiTimeEntry* currentTimeEntry;

}

- (void) newEntry:(NSString*)entry;
- (void) stopCurrentEntry;
- (NSArray*) todaysEntries;
- (NSArray*) recentEntries;
- (float) todaysSum;
- (void) reload;
- (void) refreshRecents;
- (void) save;
@property (retain) HtiTimeEntry* currentTimeEntry;


@end
