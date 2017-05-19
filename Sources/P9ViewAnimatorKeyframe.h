//
//  P9ViewAnimatorKeyframe.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;
#import "P9ViewAnimatorDefine.h"

typedef NS_ENUM(NSInteger, P9ViewAnimatorKeyframeType)
{
    P9ViewAnimatorKeyframeTypeDummy,
    P9ViewAnimatorKeyframeTypeFrameAni,
    P9ViewAnimatorKeyframeTypeMorphTargetName,
    P9ViewAnimatorKeyframeTypeMorphTargetView,
    P9ViewAnimatorKeyframeTypeMorphTargetFrame,
    P9ViewAnimatorKeyframeTypeAlpha,
    P9ViewAnimatorKeyframeTypeTranslate,
    P9ViewAnimatorKeyframeTypeRotate,
    P9ViewAnimatorKeyframeTypeScale,
    P9ViewAnimatorKeyframeTypeAdlib
};

typedef NS_ENUM(NSInteger, P9ViewAnimatorInterpolationType)
{
    P9ViewAnimatorInterpolationTypeLinear,
    P9ViewAnimatorInterpolationTypeEaseIn,
    P9ViewAnimatorInterpolationTypeEaseOut,
    P9ViewAnimatorInterpolationTypeEaseInOut
};

@interface P9ViewAnimatorKeyframe : NSObject

@property (nonatomic, assign) P9ViewAnimatorKeyframeType type;
@property (nonatomic, assign) P9ViewAnimatorInterpolationType itprType;
@property (nonatomic, assign) NSTimeInterval after;
@property (nonatomic, strong) NSString * _Nullable targetName;
@property (nonatomic, strong) UIView * _Nullable targetView;
@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat z;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat anchorX;
@property (nonatomic, assign) CGFloat anchorY;
@property (nonatomic, strong) P9ViewAnimatorActionBlock _Nullable adlib;

@end
