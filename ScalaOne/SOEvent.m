//
//  SOEvent.m
//  ScalaOne
//
//  Created by Jean-Pierre Simard on 9/4/12.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "SOEvent.h"
#import "SOSpeaker.h"
#import "SOUser.h"


@implementation SOEvent

@dynamic code;
@dynamic end;
@dynamic location;
@dynamic remoteID;
@dynamic start;
@dynamic textDescription;
@dynamic title;
@dynamic day;
@dynamic favoriteUser;
@dynamic speakers;

- (NSDate *) day {
//    Return start date without time components
    
    [self willAccessValueForKey:@"day"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [df stringFromDate:[self start]];
    NSDate *eventDay = [df dateFromString:dateString];
    
    [self didAccessValueForKey:@"day"];
    
    return eventDay;
}

@end