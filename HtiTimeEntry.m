//
//  HtiTimeEntry.m
//  HopToIt
//
//  Created by Matthew Henderson on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtiTimeEntry.h"
#import "HtiUtilities.h"

@interface HtiTimeEntry ()
- (void) setStartTimeFromString:(NSString*) startString;
- (void) setEndTimeFromString:(NSString*) endString;
@end
@implementation HtiTimeEntry

@synthesize timeEntryDescription;
@synthesize startTime;
@synthesize endTime;

- (id) initWithDesciption:(NSString*) newDescription{
	if (self = [super init]) {
		self.timeEntryDescription = newDescription;
		self.startTime = [NSDate date];
		self.endTime = [NSDate date];
	}
	return self;
}

+ (HtiTimeEntry*) timeEntryFromFormattedString:(NSString*) fString{
	NSLog(@"%@", fString);			
	NSScanner *aScanner = [NSScanner scannerWithString:fString];
	NSString *desc;
	NSString *skip;
	NSString *startString;
	NSString *endString;
	NSString *start = @"{";
	NSString *end = @"}";
	[aScanner scanUpToString:start intoString:&desc];
	[aScanner scanUpToString:end intoString:&startString];
	[aScanner scanUpToString:start intoString:&skip];
	[aScanner scanUpToString:end intoString:&endString];
	
	startString = [startString substringFromIndex:1];
	endString = [endString substringFromIndex:1];
	NSLog(@"desc = %@", desc);
	NSLog(@"startString = %@", startString);
	NSLog(@"endString = %@", endString);
	HtiTimeEntry* entry = [[HtiTimeEntry alloc] initWithDesciption:desc];
	[entry setStartTimeFromString:startString];
	[entry setEndTimeFromString:endString];
	return [entry autorelease];
}

- (void) setStartTimeFromString:(NSString*) startString{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HH:mm:ss"];
	self.startTime = [formatter dateFromString:startString];
}

- (void) setEndTimeFromString:(NSString*) endString{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HH:mm:ss"];
	self.endTime = [formatter dateFromString:endString];
}

- (void) start{
	self.startTime = [NSDate date];
}
- (void) end{
	self.endTime = [NSDate date];
}

- (NSString*)description
{	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HH:mm:ss"];
    return [NSString stringWithFormat:@"%@{%@}{%@}", self.timeEntryDescription, [formatter stringFromDate:self.startTime], [formatter stringFromDate:self.endTime]];
}

- (NSString*) summary {
	NSDate* roundedStart = [HtiUtilities roundDate:self.startTime toMinutes:5.0];
	NSDate* roundedEnd = [HtiUtilities roundDate:self.endTime toMinutes:5.0];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"hh:mm a"];
	return [NSString stringWithFormat:@"%@ - %@ to %@", self.timeEntryDescription, [formatter stringFromDate:roundedStart], [formatter stringFromDate:roundedEnd]];

}

@end
