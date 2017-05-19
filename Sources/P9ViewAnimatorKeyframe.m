//
//  P9ViewAnimatorKeyframe.m
//  
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

#import "P9ViewAnimatorKeyframe.h"

@implementation P9ViewAnimatorKeyframe

- (instancetype)init
{
    if( (self = [super init]) != nil ) {
        _type = P9ViewAnimatorKeyframeTypeDummy;
        _itprType = P9ViewAnimatorInterpolationTypeLinear;
        _velocity = 1.0;
        _alpha = 1.0;
        _anchorX = 0.5;
        _anchorY = 0.5;
    }
    
    return self;
}

@end
