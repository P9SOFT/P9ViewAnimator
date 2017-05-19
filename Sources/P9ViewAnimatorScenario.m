//
//  P9ViewAnimatorScenario.m
//  
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

#import "P9ViewAnimatorScenario.h"

@implementation P9ViewAnimatorScenario

- (instancetype)init
{
    if( (self = [super init]) != nil ) {
        
        if( (_keyframes = [NSMutableArray new]) == nil ) {
            return nil;
        }
        
    }
    
    return self;
}

@end
