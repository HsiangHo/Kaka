//
//  HAFUserBehaviorManager.m
//  USB Block
//
//  Created by Jovi on 6/18/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "HAFUserBehaviorManager.h"
#import <Security/SecRequirement.h>

static HAFUserBehaviorManager *instance;
@implementation HAFUserBehaviorManager

+(instancetype)sharedManager{
    @synchronized(self){
        if (nil == instance) {
            instance = [[HAFUserBehaviorManager alloc] init];
        }
        return instance;
    }
}

-(BOOL)superMode{
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.year = YEAR;
    dateComponents.month = MONTH;
    dateComponents.day = DAY;
    dateComponents.hour = HOUR;
    dateComponents.minute = MINUTE;
    dateComponents.second = SECOND;
    
    NSDate *validDate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    NSDate *todaysDate = [NSDate date];
    
    return ([todaysDate earlierDate:validDate] != todaysDate);
}

@end
