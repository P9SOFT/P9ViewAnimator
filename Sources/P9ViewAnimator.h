//
//  P9ViewAnimator.h
//
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import UIKit;
@import QuartzCore;
#import "P9ViewAnimatorDefine.h"
#import "P9ViewAnimatorKeyframe.h"
#import "P9ViewAnimatorScenario.h"
#import "P9ViewAnimatorScript.h"

@interface P9ViewAnimator : NSObject

+ (P9ViewAnimator *)defaultP9ViewAnimator;

//- (BOOL)loadScenariosFromFile:(NSString *)filePath overwrite:(BOOL)overwrite;
//- (BOOL)loadScenariosFromData:(NSData *)data overwrite:(BOOL)overwrite;
//- (BOOL)loadScenariosFromDict:(NSDictionary *)scenarioDict overwrie:(BOOL)overwrite;

- (BOOL)createScenario:(NSString *)scenarioName;
- (void)removeScenarioForName:(NSString *)scenarioName;
- (void)removeAllScenarios;

- (BOOL)addKeyframeFrameAniToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetName:(NSString *)targetName velopcity:(CGFloat)velocity loop:(BOOL)loop itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetName:(NSString *)targetName itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetView:(UIView *)targetView itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetFrame:(CGRect)targetFrame itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeAlphaToScenario:(NSString *)scenarioName after:(NSTimeInterval)after alpha:(CGFloat)alpha itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeTranslateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateXToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateXToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateYToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateYToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateZToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateZToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeScaleToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeScaleToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeActionToScenario:(NSString *)scenarioName after:(NSTimeInterval)after adlib:(P9ViewAnimatorActionBlock)adlib;

- (void)action:(UIView *)actorView withScenario:(NSString *)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject beginning:(P9ViewAnimatorActionBlock)beginning completion:(P9ViewAnimatorActionBlock)completion;
- (void)actionDecoy:(UIView *)actorView onStageView:(UIView *)stageView withScenario:(NSString *)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject beginning:(P9ViewAnimatorActionBlock)beginning completion:(P9ViewAnimatorActionBlock)completion;
- (void)stopAction:(UIView *)actorView;
- (void)stopAllActions;

@property (nonatomic, strong) UIView *defaultStageView;

@end
