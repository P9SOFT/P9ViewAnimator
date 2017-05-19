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

+ (P9ViewAnimator * _Nonnull)defaultP9ViewAnimator;

- (BOOL)loadScenariosFromFile:(NSString * _Nullable)filePath overwrite:(BOOL)overwrite;
- (BOOL)loadScenariosFromData:(NSData * _Nullable)data overwrite:(BOOL)overwrite;
- (BOOL)loadScenariosFromDict:(NSDictionary * _Nullable)scenarioDict overwrie:(BOOL)overwrite;

- (BOOL)createScenario:(NSString * _Nullable)scenarioName;
- (void)removeScenarioForName:(NSString * _Nullable)scenarioName;
- (void)removeAllScenarios;

- (BOOL)addKeyframeFrameAniToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after targetName:(NSString * _Nullable)targetName velopcity:(CGFloat)velocity loop:(BOOL)loop itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after targetName:(NSString * _Nullable)targetName itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after targetView:(UIView * _Nullable)targetView itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeMorphToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after targetFrame:(CGRect)targetFrame itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeAlphaToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after alpha:(CGFloat)alpha itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeTranslateToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateXToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateXToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateYToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateYToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateZToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateZToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeScaleToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeScaleToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeActionToScenario:(NSString * _Nullable)scenarioName after:(NSTimeInterval)after adlib:(P9ViewAnimatorActionBlock _Nullable)adlib;

- (void)action:(UIView * _Nullable)actorView withScenario:(NSString * _Nullable)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol> _Nullable)targetObject beginning:(P9ViewAnimatorActionBlock _Nullable)beginning completion:(P9ViewAnimatorActionBlock _Nullable)completion;
- (void)actionDecoy:(UIView * _Nullable)actorView onStageView:(UIView * _Nullable)stageView withScenario:(NSString * _Nullable)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol> _Nullable)targetObject beginning:(P9ViewAnimatorActionBlock _Nullable)beginning completion:(P9ViewAnimatorActionBlock _Nullable)completion;
- (void)stopAction:(UIView * _Nullable)actorView;
- (void)stopAllActions;

@property (nonatomic, strong) UIView * _Nullable defaultStageView;

@end
