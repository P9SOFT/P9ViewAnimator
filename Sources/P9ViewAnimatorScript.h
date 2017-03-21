//
//  P9ViewAnimatorScript.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;
#import "P9ViewAnimatorDefine.h"

@interface P9ViewAnimatorScript : NSObject

@property (nonatomic, strong) NSString *scenarioName;
@property (nonatomic, strong) UIView *actorView;
@property (nonatomic, assign) CGRect actorViewOriginFrame;
@property (nonatomic, strong) UIView *decoyView;
@property (nonatomic, strong) NSMutableArray *keyframes;
@property (nonatomic, strong) id<P9ViewAnimatorTargetObjectProtocol> targetObject;
@property (nonatomic, strong) P9ViewAnimatorActionBlock beginning;
@property (nonatomic, strong) P9ViewAnimatorActionBlock completion;

@end
