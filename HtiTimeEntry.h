//
//  HtiTimeEntry.h
//  HopToIt
//
//  Created by Matthew Henderson on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HtiTimeEntry : NSObject {
	NSString* timeEntryDescription;
	NSDate* startTime;
	NSDate* endTime;
}
@property (copy) NSString* timeEntryDescription;
@property (retain) NSDate* startTime;
@property (retain) NSDate* endTime;

- (id) initWithDesciption:(NSString*) newDescription;
+ (HtiTimeEntry*) timeEntryFromFormattedString:(NSString*) fString; 
- (void) start;
- (void) end;
- (NSString*) summary;
//- (float) duration;

@end
