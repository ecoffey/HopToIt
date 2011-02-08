//
//  HtiUtilities.m
//  HopToIt
//
//  Created by Matthew Henderson on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HtiUtilities.h"


@implementation HtiUtilities
+(NSDate*) roundDate:(NSDate*)dateToRound toMinutes:(float) minutesToRoundTo{
	NSDateComponents *time = [[NSCalendar currentCalendar]
							  components:NSHourCalendarUnit | NSMinuteCalendarUnit
							  fromDate:dateToRound];
	NSInteger minutes = [time minute];
	float minuteUnit = ceil((float) minutes / 5.0);
	minutes = minuteUnit * 5.0;
	[time setMinute: minutes];
	return [[NSCalendar currentCalendar] dateFromComponents:time];
}

@end
