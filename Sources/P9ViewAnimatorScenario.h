//
//  P9ViewAnimatorScenario.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;
#import "P9ViewAnimatorDefine.h"
#import "P9ViewAnimatorKeyframe.h"

@interface P9ViewAnimatorScenario : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *keyframes;
@property (nonatomic, strong) P9ViewAnimatorActionBlock beginning;
@property (nonatomic, strong) P9ViewAnimatorActionBlock completion;

@end
