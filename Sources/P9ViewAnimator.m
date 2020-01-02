//
//  P9ViewAnimator.m
//  
//
//  Created by Tae Hyun Na on 2016. 2. 3.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

#import "P9ViewAnimator.h"

#define     TO_RADIAN(x)        (x*(M_PI/180.0))
#define     TO_DEGREE(x)        (x*(180.0/M_PI))

@interface P9ViewAnimator ()

- (BOOL)addKeyframeRotateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z itprType:(P9ViewAnimatorInterpolationType)itprType;
- (BOOL)addKeyframeRotateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType;
- (NSString *)keyForObject:(id)anObject;
- (P9ViewAnimatorKeyframe *)keyframeForAddType:(P9ViewAnimatorKeyframeType)type after:(NSTimeInterval)after fromKeyframes:(NSMutableArray *)keyframes;
- (void)changeAnchor:(CGPoint)anchor forView:(UIView *)view;
- (void)startPumpingForScript:(P9ViewAnimatorScript *)script delay:(NSTimeInterval)delay;
- (void)pumpKeyframeForScript:(P9ViewAnimatorScript *)script;
- (void)updateActorView:(UIView *)actorView withKeyframe:(P9ViewAnimatorKeyframe *)keyframe;
- (void)addAnimationToActorView:(UIView *)actorView withKeyframe:(P9ViewAnimatorKeyframe *)keyframe suggestedDuration:(NSTimeInterval)suggestedDuration targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject;
- (CAKeyframeAnimation *)makeCAKeyframeWithKeyPath:(NSString *)keyPath itprType:(P9ViewAnimatorInterpolationType)itprType;
- (void)clearScript:(P9ViewAnimatorScript *)script;

@property (nonatomic, readonly) NSMutableDictionary *scenarioDict;
@property (nonatomic, readonly) NSMutableDictionary *actorViewDict;

@end

@implementation P9ViewAnimator

+ (P9ViewAnimator *)defaultP9ViewAnimator
{
    static dispatch_once_t once;
    static P9ViewAnimator *sharedInstance;
    dispatch_once(&once, ^{sharedInstance = [self new];});
    return sharedInstance;
}

- (instancetype)init
{
    if( (self = [super init]) != nil ) {
        
        if( (_scenarioDict = [NSMutableDictionary new]) == nil ) {
            return nil;
        }
        if( (_actorViewDict = [NSMutableDictionary new]) == nil ) {
            return nil;
        }
        
    }
    
    return self;
}

- (BOOL)loadScenariosFromFile:(NSString *)filePath overwrite:(BOOL)overwrite
{
    if( filePath.length == 0 ) {
        return NO;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self loadScenariosFromData:data overwrite:overwrite];
}

- (BOOL)loadScenariosFromData:(NSData *)data overwrite:(BOOL)overwrite
{
    if( data == nil ) {
        return NO;
    }
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if( [jsonObject isKindOfClass:[NSDictionary class]] == NO ) {
        return NO;
    }
    return [self loadScenariosFromDict:jsonObject overwrie:overwrite];
}

- (BOOL)loadScenariosFromDict:(NSDictionary *)scenarioDict overwrie:(BOOL)overwrite
{
    NSDictionary *keyframeTypeDict = @{
                                        P9ViewAnimatorAttributeTypeFrameAni:@(P9ViewAnimatorKeyframeTypeFrameAni),
                                        P9ViewAnimatorAttributeTypeMorph:@(P9ViewAnimatorKeyframeTypeMorphTargetName),
                                        P9ViewAnimatorAttributeTypeAlpha:@(P9ViewAnimatorKeyframeTypeAlpha),
                                        P9ViewAnimatorAttributeTypeTranslate:@(P9ViewAnimatorKeyframeTypeTranslate),
                                        P9ViewAnimatorAttributeTypeRotateX:@(P9ViewAnimatorKeyframeTypeRotate),
                                        P9ViewAnimatorAttributeTypeRotateY:@(P9ViewAnimatorKeyframeTypeRotate),
                                        P9ViewAnimatorAttributeTypeRotateZ:@(P9ViewAnimatorKeyframeTypeRotate),
                                        P9ViewAnimatorAttributeTypeScale:@(P9ViewAnimatorKeyframeTypeScale)
                                       };
    NSDictionary *interpolationDict = @{
                                        P9ViewAnimatorAttributeInterpolationLinear:@(P9ViewAnimatorInterpolationTypeLinear),
                                        P9ViewAnimatorAttributeInterpolationEaseIn:@(P9ViewAnimatorInterpolationTypeEaseIn),
                                        P9ViewAnimatorAttributeInterpolationEaseOut:@(P9ViewAnimatorInterpolationTypeEaseOut),
                                        P9ViewAnimatorAttributeInterpolationEaseInOut:@(P9ViewAnimatorInterpolationTypeEaseInOut),
                                       };
    
    @synchronized (self) {
        for(NSString *scenarioName in scenarioDict) {
            if( overwrite == YES ) {
                [self removeScenarioForName:scenarioName];
            }
            if( [self createScenario:scenarioName] == NO ) {
                continue;
            }
            P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
            NSArray *keyframeList = scenarioDict[scenarioName];
            for(NSDictionary *keyframeDict in keyframeList) {
                NSString *keyframeTypeValue = keyframeDict[P9ViewAnimatorAttributeType];
                P9ViewAnimatorKeyframeType type = (keyframeTypeValue != nil) ? (P9ViewAnimatorKeyframeType)[keyframeTypeDict[keyframeTypeValue] integerValue] : P9ViewAnimatorKeyframeTypeTranslate;
                NSTimeInterval after = (NSTimeInterval)[keyframeDict[P9ViewAnimatorAttributeAfter] doubleValue];
                NSString *targetName = keyframeDict[P9ViewAnimatorAttributeTarget];
                CGFloat velocity = (keyframeDict[P9ViewAnimatorAttributeVelocity] != nil) ? (CGFloat)[keyframeDict[P9ViewAnimatorAttributeVelocity] floatValue] : 1.0;
                BOOL loop = [keyframeDict[P9ViewAnimatorAttributeLoop] boolValue];
                CGFloat alpha = (keyframeDict[P9ViewAnimatorAttributeTypeAlpha] != nil) ? (CGFloat)[keyframeDict[P9ViewAnimatorAttributeTypeAlpha] floatValue] : 1.0;
                CGFloat x = (CGFloat)[keyframeDict[P9ViewAnimatorAttributeX] floatValue];
                CGFloat y = (CGFloat)[keyframeDict[P9ViewAnimatorAttributeY] floatValue];
                CGFloat z = (CGFloat)[keyframeDict[P9ViewAnimatorAttributeZ] floatValue];
                CGFloat angle = (CGFloat)[keyframeDict[P9ViewAnimatorAttributeAngle] floatValue];
                CGFloat anchorX = (keyframeDict[P9ViewAnimatorAttributeAnchorX] != nil) ? (CGFloat)[keyframeDict[P9ViewAnimatorAttributeAnchorX] floatValue] : 0.5;
                CGFloat anchorY = (keyframeDict[P9ViewAnimatorAttributeAnchorY] != nil) ? (CGFloat)[keyframeDict[P9ViewAnimatorAttributeAnchorY] floatValue] : 0.5;
                P9ViewAnimatorInterpolationType itprType = (keyframeDict[P9ViewAnimatorAttributeInterpolation] != nil) ? (P9ViewAnimatorInterpolationType)[interpolationDict[keyframeDict[P9ViewAnimatorAttributeInterpolation]] integerValue] : P9ViewAnimatorInterpolationTypeLinear;
                BOOL knownData = YES;
                switch( type ) {
                    case P9ViewAnimatorKeyframeTypeFrameAni :
                        if( targetName == nil ) {
                            knownData = NO;
                        }
                        break;
                    case P9ViewAnimatorKeyframeTypeMorphTargetName :
                        if( targetName == nil ) {
                            knownData = NO;
                        }
                        break;
                    case P9ViewAnimatorKeyframeTypeAlpha :
                        if( (alpha < 0.0) || (alpha > 1.0) ) {
                            knownData = NO;
                        }
                        break;
                    case P9ViewAnimatorKeyframeTypeTranslate :
                    case P9ViewAnimatorKeyframeTypeScale :
                        break;
                    case P9ViewAnimatorKeyframeTypeRotate :
                        if( [keyframeTypeValue isEqualToString:P9ViewAnimatorAttributeTypeRotateX] == YES ) {
                            x = 1.0;
                            y = z = 0.0;
                        } else if( [keyframeTypeValue isEqualToString:P9ViewAnimatorAttributeTypeRotateY] == YES ) {
                            y = 1.0;
                            x = z = 0.0;
                        } else {
                            z = 1.0;
                            x = y = 0.0;
                        }
                        break;
                    default :
                        knownData = NO;
                        break;
                }
                if( knownData == NO ) {
                    type = P9ViewAnimatorKeyframeTypeTranslate;
                    x = y = z = 0.0;
                }
                P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:type after:after fromKeyframes:scenario.keyframes];
                if( keyframe == nil ) {
                    continue;
                }
                switch( type ) {
                    case P9ViewAnimatorKeyframeTypeFrameAni :
                        keyframe.targetName = targetName;
                        keyframe.velocity = velocity;
                        keyframe.loop = loop;
                        keyframe.itprType = itprType;
                        break;
                    case P9ViewAnimatorKeyframeTypeMorphTargetName :
                        keyframe.targetName = targetName;
                        keyframe.itprType = itprType;
                        break;
                    case P9ViewAnimatorKeyframeTypeAlpha :
                        keyframe.alpha = alpha;
                        keyframe.itprType = itprType;
                        break;
                    case P9ViewAnimatorKeyframeTypeTranslate :
                        keyframe.x = x;
                        keyframe.y = y;
                        keyframe.z = 0.0;
                        keyframe.itprType = itprType;
                        break;
                    case P9ViewAnimatorKeyframeTypeRotate :
                        keyframe.angle = angle;
                        keyframe.x = x;
                        keyframe.y = y;
                        keyframe.z = z;
                        keyframe.anchorX = anchorX;
                        keyframe.anchorY = anchorY;
                        keyframe.itprType = itprType;
                        break;
                    case P9ViewAnimatorKeyframeTypeScale :
                        keyframe.x = x;
                        keyframe.y = y;
                        keyframe.z = 1.0;
                        keyframe.anchorX = anchorX;
                        keyframe.anchorY = anchorY;
                        keyframe.itprType = itprType;
                        break;
                    default :
                        return NO;
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)createScenario:(NSString *)scenarioName
{
    if( scenarioName.length == 0 ) {
        return NO;
    }
    
    BOOL created = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario == nil ) {
            if( (scenario = [P9ViewAnimatorScenario new]) != nil ) {
                scenario.name = scenarioName;
                _scenarioDict[scenarioName] = scenario;
                created = YES;
            }
        }
    }
    
    return created;
}

- (void)removeScenarioForName:(NSString *)scenarioName
{
    if( scenarioName.length == 0 ) {
        return;
    }
    @synchronized (self) {
        [_scenarioDict removeObjectForKey:scenarioName];
    }
}

- (void)removeAllScenarios
{
    @synchronized (self) {
        [_scenarioDict removeAllObjects];
    }
}

- (BOOL)addKeyframeFrameAniToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetName:(NSString *)targetName velopcity:(CGFloat)velocity loop:(BOOL)loop itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) || (targetName.length == 0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeFrameAni after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.targetName = targetName;
                keyframe.velocity = velocity;
                keyframe.loop = loop;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetName:(NSString *)targetName itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) || (targetName.length == 0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeMorphTargetName after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.targetName = targetName;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetView:(UIView *)targetView itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) || (targetView == nil) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeMorphTargetView after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.targetView = targetView;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeMorphToScenario:(NSString *)scenarioName after:(NSTimeInterval)after targetFrame:(CGRect)targetFrame itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) || (targetFrame.size.width < 0.0) || (targetFrame.size.height < 0.0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeMorphTargetFrame after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.targetFrame = targetFrame;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeAlphaToScenario:(NSString *)scenarioName after:(NSTimeInterval)after alpha:(CGFloat)alpha itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) || (alpha < 0.0) || (alpha > 1.0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeAlpha after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.alpha = alpha;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeTranslateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeTranslate after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.x = x;
                keyframe.y = y;
                keyframe.z = 0.0;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeRotateXToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:1.0 y:0.0 z:0.0 itprType:itprType];
}

- (BOOL)addKeyframeRotateXToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:1.0 y:0.0 z:0.0 anchorX:anchorX anchorY:anchorY itprType:itprType];
}

- (BOOL)addKeyframeRotateYToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:0.0 y:1.0 z:0.0 itprType:itprType];
}

- (BOOL)addKeyframeRotateYToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:0.0 y:1.0 z:0.0 anchorX:anchorX anchorY:anchorY itprType:itprType];
}

- (BOOL)addKeyframeRotateZToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:0.0 y:0.0 z:1.0 itprType:itprType];
}

- (BOOL)addKeyframeRotateZToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:0.0 y:0.0 z:1.0 anchorX:anchorX anchorY:anchorY itprType:itprType];
}

- (BOOL)addKeyframeRotateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeRotateToScenario:scenarioName after:after angle:angle x:x y:y z:z anchorX:0.5 anchorY:0.5 itprType:itprType];
}

- (BOOL)addKeyframeRotateToScenario:(NSString *)scenarioName after:(NSTimeInterval)after angle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeRotate after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.angle = angle;
                keyframe.x = x;
                keyframe.y = y;
                keyframe.z = z;
                keyframe.anchorX = anchorX;
                keyframe.anchorY = anchorY;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeScaleToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y itprType:(P9ViewAnimatorInterpolationType)itprType
{
    return [self addKeyframeScaleToScenario:scenarioName after:after x:x y:y anchorX:0.5 anchorY:0.5 itprType:itprType];
}

- (BOOL)addKeyframeScaleToScenario:(NSString *)scenarioName after:(NSTimeInterval)after x:(CGFloat)x y:(CGFloat)y anchorX:(CGFloat)anchorX anchorY:(CGFloat)anchorY itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( (scenarioName.length == 0) || (after < 0.0) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [self keyframeForAddType:P9ViewAnimatorKeyframeTypeScale after:after fromKeyframes:scenario.keyframes];
            if( keyframe != nil ) {
                keyframe.x = x;
                keyframe.y = y;
                keyframe.z = 1.0;
                keyframe.anchorX = anchorX;
                keyframe.anchorY = anchorY;
                keyframe.itprType = itprType;
                added = YES;
            }
        }
    }
    
    return added;
}

- (BOOL)addKeyframeActionToScenario:(NSString *)scenarioName after:(NSTimeInterval)after adlib:(P9ViewAnimatorActionBlock)adlib
{
    if( (scenarioName.length == 0) || (after < 0.0) || (adlib == nil) ) {
        return NO;
    }
    
    BOOL added = NO;
    
    @synchronized (self) {
        P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
        if( scenario != nil ) {
            P9ViewAnimatorKeyframe *keyframe = [P9ViewAnimatorKeyframe new];
            keyframe.type = P9ViewAnimatorKeyframeTypeScale;
            keyframe.after = after;
            keyframe.adlib = adlib;
            [scenario.keyframes addObject:keyframe];
            added = YES;
        }
    }
    
    return added;
}

- (void)action:(UIView *)actorView withScenario:(NSString *)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject beginning:(P9ViewAnimatorActionBlock)beginning completion:(P9ViewAnimatorActionBlock)completion
{
    BOOL failed = YES;
    P9ViewAnimatorScript *script = nil;
    
    if( (actorView != nil) && (scenarioName.length > 0) && (delay >= 0.0) ) {
        script = [P9ViewAnimatorScript new];
        @synchronized (self) {
            if( _actorViewDict[[self keyForObject:actorView]] == nil ) {
                P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
                if( (script != nil) && (scenario != nil) ) {
                    script.scenarioName = scenarioName;
                    script.actorView = actorView;
                    script.actorViewOriginFrame = actorView.frame;
                    script.keyframes = [[NSMutableArray alloc] initWithArray:scenario.keyframes];
                    script.targetObject = targetObject;
                    script.beginning = beginning;
                    script.completion = completion;
                    _actorViewDict[[self keyForObject:actorView]] = actorView;
                    failed = NO;
                }
            }
        }
    }
    
    if( failed == YES ) {
        if( beginning != nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginning(actorView);
                if( completion != nil ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(actorView);
                    });
                }
            });
        }
        return;
    }
    
    [self startPumpingForScript:script delay:delay];
}

- (void)actionDecoy:(UIView *)actorView onStageView:(UIView *)stageView withScenario:(NSString *)scenarioName delay:(NSTimeInterval)delay targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject beginning:(P9ViewAnimatorActionBlock)beginning completion:(P9ViewAnimatorActionBlock)completion
{
    BOOL failed = YES;
    P9ViewAnimatorScript *script = nil;
    
    UIGraphicsBeginImageContextWithOptions(actorView.bounds.size, false, [UIScreen mainScreen].scale);
    [actorView drawViewHierarchyInRect:actorView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *decoyView = [[UIImageView alloc] initWithImage:image];
    
    UIView *currentStageView = (stageView != nil) ? stageView : _defaultStageView;
    
    if( (actorView != nil) && (scenarioName.length > 0) && (delay >= 0.0) && (decoyView != nil) && (currentStageView != nil) ) {
        UIView *parentView = (actorView.superview != nil) ? actorView.superview : actorView;
        decoyView.frame = [currentStageView convertRect:actorView.frame fromView:parentView];
        script = [P9ViewAnimatorScript new];
        @synchronized (self) {
            if( _actorViewDict[[self keyForObject:actorView]] == nil ) {
                P9ViewAnimatorScenario *scenario = _scenarioDict[scenarioName];
                if( (script != nil) && (scenario != nil) ) {
                    [currentStageView addSubview:decoyView];
                    script.scenarioName = scenarioName;
                    script.actorView = actorView;
                    script.actorViewOriginFrame = actorView.frame;
                    script.decoyView = decoyView;
                    script.keyframes = [[NSMutableArray alloc] initWithArray:scenario.keyframes];
                    script.targetObject = targetObject;
                    script.beginning = beginning;
                    script.completion = completion;
                    _actorViewDict[[self keyForObject:actorView]] = actorView;
                    failed = NO;
                }
            }
        }
    }
    
    if( failed == YES ) {
        if( beginning != nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                beginning(actorView);
                if( completion != nil ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(actorView);
                    });
                }
            });
        }
        return;
    }
    
    [self startPumpingForScript:script delay:delay];
}

- (void)stopAction:(UIView *)actorView
{
    if( actorView == nil ) {
        return;
    }
    
    NSString *key = [self keyForObject:actorView];
    @synchronized (self) {
        if( _actorViewDict[key] != nil ) {
            [_actorViewDict removeObjectForKey:key];
            [actorView.layer removeAllAnimations];
        }
    }
}

- (void)stopAllActions
{
    @synchronized (self) {
        for(UIView *view in _actorViewDict.objectEnumerator) {
            [view.layer removeAllAnimations];
        }
        [_actorViewDict removeAllObjects];
    }
}

- (NSString *)keyForObject:(id)anObject
{
    return [NSString stringWithFormat:@"%lx", (unsigned long)[anObject hash]];
}

- (P9ViewAnimatorKeyframe *)keyframeForAddType:(P9ViewAnimatorKeyframeType)type after:(NSTimeInterval)after fromKeyframes:(NSMutableArray *)keyframes
{
    P9ViewAnimatorKeyframe *keyframe = nil;
    NSInteger insertIndex = -1;
    if( (keyframes.count > 0) && (after == 0.0) ) {
        for(NSInteger i=keyframes.count-1 ; i>=0 ; --i) {
            P9ViewAnimatorKeyframe *checkKeyframe = keyframes[i];
            if( checkKeyframe.after > 0.0 ) {
                if( (i == (keyframes.count - 1)) && (checkKeyframe.type == type) ) {
                    keyframe = checkKeyframe;
                }
                break;
            }
            if( checkKeyframe.type == type ) {
                keyframe = checkKeyframe;
                break;
            }
            if( (type == P9ViewAnimatorKeyframeTypeRotate) || (type == P9ViewAnimatorKeyframeTypeScale) ) {
                if( checkKeyframe.type == P9ViewAnimatorKeyframeTypeTranslate ) {
                    insertIndex = i;
                }
            }
        }
    }
    if( keyframe == nil ) {
        keyframe = [P9ViewAnimatorKeyframe new];
        keyframe.type = type;
        keyframe.after = after;
        if( insertIndex >= 0 ) {
            [keyframes insertObject:keyframe atIndex:insertIndex];
        } else {
            [keyframes addObject:keyframe];
        }
    }
    return keyframe;
}

- (void)changeAnchor:(CGPoint)anchor forView:(UIView *)view
{
    if( view == nil ) {
        return;
    }
    if( CGPointEqualToPoint(view.layer.anchorPoint, anchor) == YES ) {
        return;
    }
    CGPoint prevOffset = CGPointMake(view.bounds.size.width*view.layer.anchorPoint.x, view.bounds.size.height*view.layer.anchorPoint.y);
    CGPoint nextOffset = CGPointMake(view.bounds.size.width*anchor.x, view.bounds.size.height*anchor.y);
    CGPoint position = view.layer.position;
    
    prevOffset = CGPointApplyAffineTransform(prevOffset, CATransform3DGetAffineTransform(view.layer.transform));
    nextOffset = CGPointApplyAffineTransform(nextOffset, CATransform3DGetAffineTransform(view.layer.transform));
    position.x += (nextOffset.x - prevOffset.x);
    position.y += (nextOffset.y - prevOffset.y);
    
    view.layer.position = position;
    view.layer.anchorPoint = anchor;
}

- (void)startPumpingForScript:(P9ViewAnimatorScript *)script delay:(NSTimeInterval)delay
{
    if( (script == nil) || (delay < 0.0) ) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        BOOL goOn = YES;
        @synchronized (self) {
            if( self->_actorViewDict[[self keyForObject:script.actorView]] == nil ) {
                goOn = NO;
            }
        }
        if( goOn == NO ) {
            [self clearScript:script];
            return;
        }
        if( script.beginning != nil ) {
            script.beginning(script.actorView);
        }
        if( script.targetObject != nil ) {
            [script.targetObject P9ViewAnimatorScenarioStarted:script.scenarioName];
        }
        UIView *realActorView = (script.decoyView != nil) ? script.decoyView : script.actorView;
        while( script.keyframes.count > 0 ) {
            P9ViewAnimatorKeyframe *keyframe = (script.keyframes).firstObject;
            if( keyframe.after > 0 ) {
                break;
            }
            [self changeAnchor:CGPointMake(keyframe.anchorX, keyframe.anchorY) forView:realActorView];
            [self updateActorView:realActorView withKeyframe:keyframe];
            [script.keyframes removeObjectAtIndex:0];
            
        }
        [self pumpKeyframeForScript:script];
    });
}

- (void)pumpKeyframeForScript:(P9ViewAnimatorScript *)script
{
    if( script == nil ) {
        return;
    }
    
    BOOL goOn = YES;
    @synchronized (self) {
        if( _actorViewDict[[self keyForObject:script.actorView]] == nil ) {
            goOn = NO;
        }
    }
    if( goOn == NO ) {
        [self clearScript:script];
        return;
    }
    
    if( script.keyframes.count == 0 ) {
        [self clearScript:script];
        if( script.completion != nil ) {
            script.completion(script.actorView);
        }
        return;
    }
    
    P9ViewAnimatorKeyframe *keyframe = (script.keyframes).firstObject;
    
    if( keyframe.type == P9ViewAnimatorKeyframeTypeMorphTargetName ) {
        if( [script.targetObject P9ViewAnimatorReadyForTargetName:keyframe.targetName] == NO ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self pumpKeyframeForScript:script];
            });
            return;
        }
    }
    
    UIView *realActorView = (script.decoyView != nil) ? script.decoyView : script.actorView;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self changeAnchor:CGPointMake(keyframe.anchorX, keyframe.anchorY) forView:realActorView];
        [self updateActorView:realActorView withKeyframe:keyframe];
        [script.keyframes removeObjectAtIndex:0];
        if( script.keyframes.count > 0 ) {
            P9ViewAnimatorKeyframe *sametimeKeyframe = (script.keyframes).firstObject;
            do {
                if( sametimeKeyframe.after > 0 ) {
                    break;
                }
                [self changeAnchor:CGPointMake(sametimeKeyframe.anchorX, sametimeKeyframe.anchorY) forView:realActorView];
                [self updateActorView:realActorView withKeyframe:sametimeKeyframe];
                [script.keyframes removeObjectAtIndex:0];
                sametimeKeyframe = (script.keyframes).firstObject;
            } while( sametimeKeyframe != nil );
        }
        [self pumpKeyframeForScript:script];
    }];
    [self addAnimationToActorView:realActorView withKeyframe:keyframe suggestedDuration:0.0 targetObject:script.targetObject];
    if( script.keyframes.count > 1 ) {
        for(NSUInteger i=1 ; i<script.keyframes.count ; ++i) {
            P9ViewAnimatorKeyframe *sametimeKeyframe = script.keyframes[i];
            if( sametimeKeyframe.after > 0 ) {
                break;
            }
            [self addAnimationToActorView:realActorView withKeyframe:sametimeKeyframe suggestedDuration:keyframe.after targetObject:script.targetObject];
        }
    }
    [CATransaction commit];
}

- (void)updateActorView:(UIView *)actorView withKeyframe:(P9ViewAnimatorKeyframe *)keyframe
{
    if( (actorView == nil) || (keyframe == nil) ) {
        return;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    
    switch (keyframe.type) {
        case P9ViewAnimatorKeyframeTypeFrameAni :
            break;
        case P9ViewAnimatorKeyframeTypeMorphTargetView :
        case P9ViewAnimatorKeyframeTypeMorphTargetName :
        case P9ViewAnimatorKeyframeTypeMorphTargetFrame :
            break;
        case P9ViewAnimatorKeyframeTypeAlpha :
            actorView.layer.opacity = keyframe.alpha;
            break;
        case P9ViewAnimatorKeyframeTypeTranslate :
        case P9ViewAnimatorKeyframeTypeRotate :
        case P9ViewAnimatorKeyframeTypeScale :
            transform = CATransform3DConcat(actorView.layer.transform, CATransform3DInvert(actorView.layer.transform));
            if( keyframe.type == P9ViewAnimatorKeyframeTypeRotate ) {
                transform = CATransform3DConcat(transform, CATransform3DMakeRotation(TO_RADIAN(keyframe.angle), keyframe.x, keyframe.y, keyframe.z));
            }
            if( keyframe.type == P9ViewAnimatorKeyframeTypeScale ) {
                transform = CATransform3DConcat(transform, CATransform3DMakeScale(keyframe.x, keyframe.y, keyframe.z));
            }
            transform = CATransform3DConcat(transform, actorView.layer.transform);
            if( keyframe.type == P9ViewAnimatorKeyframeTypeTranslate ) {
                transform = CATransform3DConcat(transform, CATransform3DMakeTranslation(keyframe.x, keyframe.y, keyframe.z));
            }
            actorView.layer.transform = transform;
            break;
        case P9ViewAnimatorKeyframeTypeAdlib :
            break;
        default:
            break;
    }
    
    [actorView.layer removeAllAnimations];
    
    if( (keyframe.type == P9ViewAnimatorKeyframeTypeAdlib) && (keyframe.adlib != nil) ) {
        keyframe.adlib(actorView);
    }
}

- (void)addAnimationToActorView:(UIView *)actorView withKeyframe:(P9ViewAnimatorKeyframe *)keyframe suggestedDuration:(NSTimeInterval)suggestedDuration targetObject:(id<P9ViewAnimatorTargetObjectProtocol>)targetObject
{
    if( (actorView == nil) || (keyframe == nil) ) {
        return;
    }
    
    [self changeAnchor:CGPointMake(keyframe.anchorX, keyframe.anchorY) forView:actorView];
    
    UIView *targetView = nil;
    CGRect targetFrame = CGRectZero;
    
    switch (keyframe.type) {
        case P9ViewAnimatorKeyframeTypeFrameAni :
            if( (keyframe.targetName.length > 0) && (targetObject != nil) ) {
                if( [targetObject respondsToSelector:@selector(P9ViewAnimatorSetLoop:forTargetName:)] == YES ) {
                    [targetObject P9ViewAnimatorSetLoop:keyframe.loop forTargetName:keyframe.targetName];
                }
                if( [targetObject respondsToSelector:@selector(P9ViewAnimatorSetVelocity:forTargetName:)] == YES ) {
                    [targetObject P9ViewAnimatorSetVelocity:keyframe.velocity forTargetName:keyframe.targetName];
                }
                if( [targetObject respondsToSelector:@selector(P9ViewAnimatorPlayTargetName:)] == YES ) {
                    [targetObject P9ViewAnimatorPlayTargetName:keyframe.targetName];
                }
            }
            break;
        case P9ViewAnimatorKeyframeTypeMorphTargetName :
            if( (keyframe.targetName.length > 0) && (targetObject != nil) ) {
                if( [targetObject respondsToSelector:@selector(P9ViewAnimatorViewForTargetName:)] == YES ) {
                    targetView = [targetObject P9ViewAnimatorViewForTargetName:keyframe.targetName];
                }
            }
        case P9ViewAnimatorKeyframeTypeMorphTargetView :
            if( targetView == nil ) {
                targetView = keyframe.targetView;
            }
        case P9ViewAnimatorKeyframeTypeMorphTargetFrame :
            if( targetView != nil ) {
                UIView *crieriaView = (actorView.superview != nil) ? actorView.superview : actorView;
                UIView *relativeView = (targetView.superview != nil) ? targetView.superview : targetView;
                targetFrame = [crieriaView convertRect:targetView.frame fromView:relativeView];
            } else {
                if( [targetObject respondsToSelector:@selector(P9ViewAnimatorFrameForTargetName:)] == YES ) {
                    targetFrame = [targetObject P9ViewAnimatorFrameForTargetName:keyframe.targetName];
                } else {
                    targetFrame = keyframe.targetFrame;
                }
            }
            CGFloat rz = TO_DEGREE([[actorView.layer valueForKeyPath:@"transform.rotation.z"] floatValue]);
            if( (rz/360.0) != 0.0 ) {
                rz = -rz;
            }
            CGFloat sx = (targetFrame.size.width/actorView.layer.bounds.size.width)*(1.0/[[actorView.layer valueForKeyPath:@"transform.scale.x"] floatValue]);
            CGFloat sy = (targetFrame.size.height/actorView.layer.bounds.size.height)*(1.0/[[actorView.layer valueForKeyPath:@"transform.scale.y"] floatValue]);
            CGFloat tx = CGRectGetMidX(targetFrame) - CGRectGetMidX(actorView.layer.frame);
            CGFloat ty = CGRectGetMidY(targetFrame) - CGRectGetMidY(actorView.layer.frame);
            if( rz != 0.0 ) {
                CAKeyframeAnimation *ka = [self makeCAKeyframeWithKeyPath:@"transform.rotation.z" itprType:keyframe.itprType];
                CGFloat r1 = TO_DEGREE([[actorView.layer valueForKeyPath:@"transform.rotation.z"] floatValue]);
                ka.values = @[@(TO_RADIAN(r1)), @(TO_RADIAN(r1+rz))];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"rotateZ"];
            }
            if( (sx != 1.0) || (sy != 1.0) ) {
                CGFloat tmp;
                CAKeyframeAnimation *ka;
                ka = [self makeCAKeyframeWithKeyPath:@"transform.scale.x" itprType:keyframe.itprType];
                tmp = [[actorView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
                ka.values = @[@(tmp), @(tmp*sx)];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"scaleX"];
                ka = [self makeCAKeyframeWithKeyPath:@"transform.scale.y" itprType:keyframe.itprType];
                tmp = [[actorView.layer valueForKeyPath:@"transform.scale.y"] floatValue];
                ka.values = @[@(tmp), @(tmp*sy)];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"scaleY"];
            }
            if( (tx != 0.0) || (tx != 0.0) ) {
                CAKeyframeAnimation *ka = [self makeCAKeyframeWithKeyPath:@"position" itprType:keyframe.itprType];
                CGPoint tmp = actorView.layer.position;
                ka.values = @[[NSValue valueWithCGPoint:tmp], [NSValue valueWithCGPoint:CGPointMake(tmp.x+tx, tmp.y+ty)]];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"translate"];
            }
            break;
        case P9ViewAnimatorKeyframeTypeAlpha :
            {
                CAKeyframeAnimation *ka = [self makeCAKeyframeWithKeyPath:@"opacity" itprType:keyframe.itprType];
                ka.values = @[@(actorView.layer.opacity), @(keyframe.alpha)];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"alpha"];
            }
            break;
        case P9ViewAnimatorKeyframeTypeTranslate :
            {
                CAKeyframeAnimation *ka = [self makeCAKeyframeWithKeyPath:@"position" itprType:keyframe.itprType];
                CGPoint tmp = actorView.layer.position;
                ka.values = @[[NSValue valueWithCGPoint:tmp], [NSValue valueWithCGPoint:CGPointMake(tmp.x+keyframe.x, tmp.y+keyframe.y)]];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"translate"];
            }
            break;
        case P9ViewAnimatorKeyframeTypeRotate :
            {
                NSString *keyPath = nil;
                NSString *key = nil;
                if( (keyframe.x == 1.0) && (keyframe.y == 0.0) && (keyframe.z == 0.0) ) {
                    keyPath = @"transform.rotation.x";
                    key = @"rotateX";
                } else if( (keyframe.x == 0.0) && (keyframe.y == 1.0) && (keyframe.z == 0.0) ) {
                    keyPath = @"transform.rotation.y";
                    key = @"rotateY";
                } else if( (keyframe.x == 0.0) && (keyframe.y == 0.0) && (keyframe.z == 1.0) ) {
                    keyPath = @"transform.rotation.z";
                    key = @"rotateZ";
                }
                if( (keyPath != nil) && (key != nil) && (keyframe.angle != 0.0) ) {
                    CAKeyframeAnimation *ka;
                    ka = [self makeCAKeyframeWithKeyPath:keyPath itprType:keyframe.itprType];
                    ka.values = @[@(TO_RADIAN(0)), @(TO_RADIAN(keyframe.angle))];
                    ka.additive = YES;
                    ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                    [actorView.layer addAnimation:ka forKey:@"rotateZ"];
                }
            }
            break;
        case P9ViewAnimatorKeyframeTypeScale :
            {
                CGFloat tmp;
                CAKeyframeAnimation *ka;
                ka = [self makeCAKeyframeWithKeyPath:@"transform.scale.x" itprType:keyframe.itprType];
                tmp = [[actorView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
                ka.values = @[@(tmp), @(tmp*keyframe.x)];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"scaleX"];
                ka = [self makeCAKeyframeWithKeyPath:@"transform.scale.y" itprType:keyframe.itprType];
                tmp = [[actorView.layer valueForKeyPath:@"transform.scale.y"] floatValue];
                ka.values = @[@(tmp), @(tmp*keyframe.y)];
                ka.duration = (suggestedDuration > 0.0) ? suggestedDuration : keyframe.after;
                [actorView.layer addAnimation:ka forKey:@"scaleY"];
            }
            break;
        case P9ViewAnimatorKeyframeTypeAdlib :
            break;
        default:
            break;
    }
}

- (CAKeyframeAnimation *)makeCAKeyframeWithKeyPath:(NSString *)keyPath itprType:(P9ViewAnimatorInterpolationType)itprType
{
    if( keyPath.length == 0 ) {
        return nil;
    }
    NSString *timingFunction = kCAMediaTimingFunctionDefault;
    switch(itprType) {
        case P9ViewAnimatorInterpolationTypeLinear :
            timingFunction = kCAMediaTimingFunctionLinear;
            break;
        case P9ViewAnimatorInterpolationTypeEaseIn :
            timingFunction = kCAMediaTimingFunctionEaseIn;
            break;
        case P9ViewAnimatorInterpolationTypeEaseOut :
            timingFunction = kCAMediaTimingFunctionEaseOut;
            break;
        case P9ViewAnimatorInterpolationTypeEaseInOut :
            timingFunction = kCAMediaTimingFunctionEaseInEaseOut;
            break;
        default :
            break;
    }
    
    CAKeyframeAnimation *ka = [CAKeyframeAnimation new];
    ka.keyPath = keyPath;
    ka.keyTimes = @[@(0), @(1)];
    ka.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    ka.removedOnCompletion = NO;
    ka.fillMode = kCAFillModeForwards;
    
    return ka;
}

- (void)clearScript:(P9ViewAnimatorScript *)script
{
    if( script == nil ) {
        return;
    }
    if( script.decoyView != nil ) {
        [script.decoyView removeFromSuperview];
        script.decoyView = nil;
    }
    @synchronized (self) {
        [_actorViewDict removeObjectForKey:[self keyForObject:script.actorView]];
    }
    if( [script.targetObject respondsToSelector:@selector(P9ViewAnimatorScenarioEnded:)] == YES ) {
        [script.targetObject P9ViewAnimatorScenarioEnded:script.scenarioName];
    }
}

@end
