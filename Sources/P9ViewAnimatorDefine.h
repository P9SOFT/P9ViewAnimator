//
//  P9ViewAnimatorDefine.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;

typedef void(^P9ViewAnimatorActionBlock)(UIView * _Nonnull actingView);

@protocol P9ViewAnimatorTargetObjectProtocol <NSObject>

- (void)P9ViewAnimatorScenarioStarted:(NSString * _Nonnull)scenarioName;
- (void)P9ViewAnimatorScenarioEnded:(NSString * _Nonnull)scenarioName;
- (BOOL)P9ViewAnimatorReadyForTargetName:(NSString * _Nonnull)targetName;

@optional
- (UIView * _Nullable)P9ViewAnimatorViewForTargetName:(NSString * _Nonnull)targetName;
- (CGRect)P9ViewAnimatorFrameForTargetName:(NSString * _Nonnull)targetName;
- (void)P9ViewAnimatorSetVelocity:(CGFloat)relativeVelocity forTargetName:(NSString * _Nonnull)targetName;
- (void)P9ViewAnimatorSetLoop:(BOOL)loop forTargetName:(NSString * _Nonnull)targetName;
- (void)P9ViewAnimatorPlayTargetName:(NSString * _Nonnull)targetName;

@end

#define     P9ViewAnimatorAttributeType             @"type"
#define     P9ViewAnimatorAttributeAfter            @"after"
#define     P9ViewAnimatorAttributeTarget           @"target"
#define     P9ViewAnimatorAttributeVelocity         @"velocity"
#define     P9ViewAnimatorAttributeLoop             @"loop"
#define     P9ViewAnimatorAttributeAlpha            @"alpha"
#define     P9ViewAnimatorAttributeX                @"x"
#define     P9ViewAnimatorAttributeY                @"y"
#define     P9ViewAnimatorAttributeZ                @"z"
#define     P9ViewAnimatorAttributeAngle            @"angle"
#define     P9ViewAnimatorAttributeAnchorX          @"anchorX"
#define     P9ViewAnimatorAttributeAnchorY          @"anchorY"
#define     P9ViewAnimatorAttributeInterpolation    @"interpolation"

#define     P9ViewAnimatorAttributeTypeFrameAni             @"frameAnimation"
#define     P9ViewAnimatorAttributeTypeMorph                @"morph"
#define     P9ViewAnimatorAttributeTypeAlpha                @"alpha"
#define     P9ViewAnimatorAttributeTypeTranslate            @"translate"
#define     P9ViewAnimatorAttributeTypeRotateX              @"rotateX"
#define     P9ViewAnimatorAttributeTypeRotateY              @"rotateY"
#define     P9ViewAnimatorAttributeTypeRotateZ              @"rotateZ"
#define     P9ViewAnimatorAttributeTypeScale                @"scale"

#define     P9ViewAnimatorAttributeInterpolationLinear      @"linear"
#define     P9ViewAnimatorAttributeInterpolationEaseIn      @"easeIn"
#define     P9ViewAnimatorAttributeInterpolationEaseOut     @"easeOut"
#define     P9ViewAnimatorAttributeInterpolationEaseInOut   @"easeInOut"
