//
//  HAFUserBehaviorManager.h
//  USB Block
//
//  Created by Jovi on 6/18/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YEAR                        2018
#define MONTH                       10
#define DAY                         5
#define HOUR                        0
#define MINUTE                      0
#define SECOND                      0

@interface HAFUserBehaviorManager : NSObject

+(instancetype)sharedManager;
-(BOOL)superMode;

@end

#define IS_SUPER_MODE      [[HAFUserBehaviorManager sharedManager] superMode]
