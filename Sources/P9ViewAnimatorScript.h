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

@property (nonatomic, strong) NSString * _Nullable scenarioName;
@property (nonatomic, strong) UIView * _Nullable actorView;
@property (nonatomic, assign) CGRect actorViewOriginFrame;
@property (nonatomic, strong) UIView * _Nullable decoyView;
@property (nonatomic, strong) NSMutableArray * _Nullable keyframes;
@property (nonatomic, strong) id<P9ViewAnimatorTargetObjectProtocol> _Nullable targetObject;
@property (nonatomic, strong) P9ViewAnimatorActionBlock _Nullable beginning;
@property (nonatomic, strong) P9ViewAnimatorActionBlock _Nullable completion;

@end
