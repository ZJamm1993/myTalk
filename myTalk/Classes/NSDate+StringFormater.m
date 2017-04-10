//
//  NSDate+StringFormater.m
//  myTalk
//
//  Created by jam on 17/4/10.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "NSDate+StringFormater.h"

@implementation NSDate (StringFormater)

-(NSString*)simpleDescription
{
    NSString* des=@"";
    NSTimeInterval interval=self.timeIntervalSinceNow;
    NSDateFormatter* forma=[[NSDateFormatter alloc]init];
    NSDateFormatter* testForma=[[NSDateFormatter alloc]init];
    [testForma setDateFormat:@"dd"];
    NSString* thisday=[testForma stringFromDate:self];
    
    NSString* todaysday=[testForma stringFromDate:[NSDate date]];
    BOOL isSameDay=[thisday isEqualToString:todaysday];
    if (interval<360&&isSameDay) {
        [forma setDateFormat:@"HH:mm"];
    }
    else
    {
        [forma setDateFormat:@"yyyy:MM:dd HH:mm"];
    }
    des=[forma stringFromDate:self];
    return des;
}

@end
