//
//  P9ViewAnimatorDefine.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;

typedef void(^P9ViewAnimatorActionBlock)(UIView *actingView);

@protocol P9ViewAnimatorTargetObjectProtocol <NSObject>

- (void)P9ViewAnimatorScenarioStarted:(NSString *)scenarioName;
- (void)P9ViewAnimatorScenarioEnded:(NSString *)scenarioName;
- (BOOL)P9ViewAnimatorReadyForTargetName:(NSString *)targetName;

@optional
- (UIView *)P9ViewAnimatorViewForTargetName:(NSString *)targetName;
- (CGRect)P9ViewAnimatorFrameForTargetName:(NSString *)targetName;
- (void)P9ViewAnimatorSetVelocity:(CGFloat)relativeVelocity forTargetName:(NSString *)targetName;
- (void)P9ViewAnimatorSetLoop:(BOOL)loop forTargetName:(NSString *)targetName;
- (void)P9ViewAnimatorPlayTargetName:(NSString *)targetName;
//- (void)P9ViewAnimatorStopTargetName:(NSString *)targetName;

@end

/*!
 JSON file attribute list
 */
//#define     P9ViewAnimatorKeyframeAfter             @"after"
//#define     P9ViewAnimatorKeyframeAlpha             @"alpha"
//#define     P9ViewAnimatorKeyframeTranslateX        @"translateX"
//#define     P9ViewAnimatorKeyframeTranslateY        @"translateY"
//#define     P9ViewAnimatorKeyframeTranslateZ        @"translateZ"
//#define     P9ViewAnimatorKeyframeRotateX           @"rotateX"
//#define     P9ViewAnimatorKeyframeRotateY           @"rotateY"
//#define     P9ViewAnimatorKeyframeRotateZ           @"rotateZ"
//#define     P9ViewAnimatorKeyframeRotateAnchorX     @"rotateAnchorX"
//#define     P9ViewAnimatorKeyframeRotateAnchorY     @"rotateAnchorY"
//#define     P9ViewAnimatorKeyframeScaleX            @"scaleX"
//#define     P9ViewAnimatorKeyframeScaleY            @"scaleY"
//#define     P9ViewAnimatorKeyframeScaleZ            @"scaleZ"
//#define     P9ViewAnimatorKeyframeScaleAnchorX      @"scaleAnchorX"
//#define     P9ViewAnimatorKeyframeScaleAnchorY      @"scaleAnchorY"
//#define     P9ViewAnimatorKeyframeFrameAni          @"frameAni"
