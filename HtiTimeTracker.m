//
//  HtiTimeTracker.m
//  HopToIt
//
//  Created by Matthew Henderson on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtiTimeTracker.h"
#import "NSFileManager+DirectoryLocations.h"
#import "HtiTimeEntry.h"

@interface HtiTimeTracker ()
- (NSString*) filePathForToday;
- (NSString*) fomattedEntry:(NSString*) description;
- (NSString*) todayString;
- (NSString*) nowString;
@end


@implementation HtiTimeTracker
@synthesize currentTimeEntry;

- (void) newEntry:(NSString*)entry{
	NSLog(@"newEntry");
	NSLog(@"1%@", _todaysEntries);
	[self stopCurrentEntry];
	HtiTimeEntry* timeEntry = [[HtiTimeEntry alloc] initWithDesciption:entry];
	[_todaysEntries addObject:timeEntry];
	NSLog(@"2%@", _todaysEntries);
	self.currentTimeEntry = timeEntry;
	[timeEntry autorelease];
	[self refreshRecents];
	NSLog(@"3%@", _todaysEntries);
	[self save];
	NSLog(@"4%@", _todaysEntries);
}

- (void) stopCurrentEntry{
	if(currentTimeEntry != nil){
		currentTimeEntry.endTime = [NSDate date];
		currentTimeEntry = nil;
	}
}


- (void) save{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* todayPath = [self filePathForToday];
	NSString* entries = @"";
	if([fileManager fileExistsAtPath:todayPath]){
		entries = [NSString stringWithContentsOfFile:todayPath];
	}
	for(int i=0; i < [_todaysEntries count]; i++){
		HtiTimeEntry* time = [_todaysEntries objectAtIndex:i];
		if (i == 0) {
			entries = [NSString stringWithFormat:@"%@",time];
		}else {
			entries = [NSString stringWithFormat:@"%@\n%@", entries, time];
		}
	}
	
	NSLog(@"write to %@ %@", entries, todayPath);
	[[entries dataUsingEncoding:NSUTF8StringEncoding] writeToFile:todayPath atomically:NO];	
}


- (NSString*) fomattedEntry:(NSString*) description{
	return [NSString stringWithFormat:@"%@{%@}", description, [self nowString]];
}

- (NSString*) todayString{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	return [formatter stringFromDate:[NSDate date]];
}

- (NSString*) nowString{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HH:mm:ss"];
	return [formatter stringFromDate:[NSDate date]];
}


- (NSString*) filePathForToday{
	NSString *supportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:supportPath]){
		NSLog(@"create %@", supportPath);
		[fileManager createDirectoryAtPath:supportPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	NSString *todayPath = [supportPath stringByAppendingPathComponent:[self todayString]];
	return todayPath;
}


- (NSArray*) todaysEntries{
	
	return _todaysEntries;
}

- (NSArray*) recentEntries{
	return _recentEntries;
}

- (float) todaysSum{
	
}

- (void) refreshRecents{
	NSMutableArray* recentForward = [[NSMutableArray alloc] initWithArray:[self todaysEntries]];
	_recentEntries = [[NSMutableArray alloc] initWithCapacity:5];
	int max = 5;
	if ([recentForward count] < 5) {
		max = [recentForward count];
	}
	for(int i=0; i < max; i++){
		[_recentEntries addObject:[recentForward objectAtIndex:[recentForward count]-1-i]];
	}
	[recentForward release];
}

- (void) reload{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* todayPath = [self filePathForToday];
	NSString* entries = @"";
	_todaysEntries = [[NSMutableArray alloc] initWithCapacity:10];
	if([fileManager fileExistsAtPath:todayPath]){
		entries = [NSString stringWithContentsOfFile:todayPath];
		NSLog(@"entries = %@", entries);
		NSArray* lines = [entries componentsSeparatedByString:@"\n"];
		NSLog(@"entries size = %d", [lines count]);
		for(NSString* line in lines){
			[_todaysEntries addObject:[HtiTimeEntry timeEntryFromFormattedString:line]];
		}
	}
	_todaysEntries;
	[self refreshRecents];
}


@end
