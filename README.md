P9ViewAnimator
============

You can easily implement animation of views based on key frame with P9ViewAnimator.

# Installation

You can download the latest framework files from our Release page.  
P9ViewAnimator also available through CocoaPods. To install it simply add the following line to your Podfile.  
pod ‘P9ViewAnimator’  

# Concept

P9ViewAnimator doing animation by handling key frame.
Make animation scenario by collection of key frames, and play actor(view) by given scenario.

# Scenario

Scenario is collection of key frames.  
So, make a scenario with name, and add key frames.

```swift
// pick a name for scenario.
let scenarioJump = "jump"

// create scenario by given name.
P9ViewAnimator.default().createScenario(scenarioJump)

// add key frame type translate decrease Y value after 1 second.
P9ViewAnimator.default().addKeyframeTranslate(toScenario: scenarioJump, after: 1.0, x: 0.0, y: -2.0, itprType: .easeIn)

// add key frame type translate increase Y value after 1 second.
P9ViewAnimator.default().addKeyframeTranslate(toScenario: scenarioJump, after: 1.0, x: 0.0, y: 2.0, itprType: .easeOut)
```

Now we made scenario some actor to moving up during 1 second and down during 1 second.  
If you want to multiple transform at the same time, add key frame after by giving zero value.

```swift
// make scenario
let scenarioSpinSizeUpDown = "spinSizeUpDown"
P9ViewAnimator.default().createScenario(scenarioSpinSizeUpDown)

// add key frame type scale up twice after 1 second.
P9ViewAnimator.default().addKeyframeScale(toScenario: scenarioSpinSizeUpDown, after: 1.0, x: 2.0, y: 2.0, itprType: .linear)
// add key frame type rotate with same time of previous key frame.
P9ViewAnimator.default().addKeyframeRotateZ(toScenario: scenarioSpinSizeUpDown, after: 0.0, angle: 180.0, itprType: .linear)
// add key frame type scale down half after 1 second.
P9ViewAnimator.default().addKeyframeScale(toScenario: scenarioSpinSizeUpDown, after: 1.0, x: 0.5, y: 0.5, itprType: .linear)
// add key frame type rotate with same time of previous key frame.
P9ViewAnimator.default().addKeyframeRotateZ(toScenario: scenarioSpinSizeUpDown, after: 0.0, angle: 180.0, itprType: .linear)
```

# Actor

To play animation, give scenario to view, like give scenario to actor.

```swift
// any view type object can be a actor
let actorView = UIImageView(named: "avatar")

// play actor with given scenario
P9ViewAnimator.default().action(actorView, withScenario: scenarioJump, delay: 0.0, targetObject: nil, beginning: nil, completion: nil) 

// scenario is reusable, so you can give scenario to another actors to play same animation.
P9ViewAnimator.default().action(anotherActorView, withScenario: scenarioJump, delay: 0.0, targetObject: nil, beginning: nil, completion: nil) 
```

You can put your own business code when animation begin or complete by passing block code.  

```swift
P9ViewAnimator.default().action(actorView, withScenario: scenarioJump, delay: 0.0, targetObject: nil, beginning: { (actorView:UIView?) in
    // do something you want when animation begining
}) { (actorView:UIView?) in
    // do something you want when animation completed
}
```

# Transform animation key frame

Transform animation with handling anchor point and interpolation type.  

```swift
// example keyframes for transform animation
P9ViewAnimator.default().addKeyframeTranslate(toScenario: scenario, after: 1.0, x: 1.0, y: 1.0, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateX(toScenario: scenario, after: 1.0, angle: 30.0, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateX(toScenario: scenario, after: 1.0, angle: 30.0, anchorX: 0.5, anchorY: 0.5, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateY(toScenario: scenario, after: 1.0, angle: 30.0, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateY(toScenario: scenario, after: 1.0, angle: 30.0, anchorX: 0.5, anchorY: 0.5, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateZ(toScenario: scenario, after: 1.0, angle: 30.0, itprType: .linear)
P9ViewAnimator.default().addKeyframeRotateZ(toScenario: scenario, after: 1.0, angle: 30.0, anchorX: 0.5, anchorY: 0.5, itprType: .linear)
P9ViewAnimator.default().addKeyframeScale(toScenario: scenario, after: 1.0, x: 2.0, y: 2.0, itprType: .linear)
P9ViewAnimator.default().addKeyframeScale(toScenario: scenario, after: 1.0, x: 2.0, y: 2.0, anchorX: 0.5, anchorY: 0.5, itprType: .linear)
```

# Alpha animation key frame

```swift
// example keyframe for alpha animation
P9ViewAnimator.default().addKeyframeAlpha(toScenario: scenario, after: 1.0, alpha: 0.5, itprType: .linear)
```

# Frame morph animation key frame

You can do resize animation one actor view to another frame, frame of some view or suggested frame dynamically by using P9ViewAnimatorTargetObjectProtocol.  

Using target frame is simple. just give frame rect value to resize.  

```swift
let targetFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
P9ViewAnimator.default().addKeyframeMorph(toScenario: scenario, after: 1.0, targetFrame: targetFrame, itprType: .linear)
```

Using target view is also simple. just vie view object to resize.  
P9ViewAnimator use frame rect of given view and animate automatically.  

```swift
let targetView = UIView(frame: CGRect(x:100, y:100, width: 100, height: 100))
P9ViewAnimator.default().addKeyframeMorph(toScenario: scenario, after: 1.0, targetView: targetView, itprType: .linear)
```

If you want to get frame rect when runtime, you need to confirm and implement P9ViewAnimatorTargetObjectProtocol.  
Here is P9ViewAnimatorTargetObjectProtocol.  

```objective-c
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
```

P9ViewAnimator call those protocol functions as their purpose when animating at activating time of key frame using target object.  
Confirm P9ViewAnimatorTargetOjectProtocol to your control area.  
For this example, we confirm and implement it to view controller.  

```swift
extension SampleViewController: P9ViewAnimatorTargetOjectProtocol {

    // called when animation start and give the name of scenario.
    func p9ViewAnimatorScenarioStarted(_ scenarioName: String) {
        print("scenario \(scenarioName) started.")
    }
    
    // called when animation complete and give the name of scenario.
    func p9ViewAnimatorScenarioEnded(_ scenarioName: String) {
        print("scenario \(scenarioName) ended.")
    }
    
    // called when key frame using target object is need to play.
    // if you ready to handling target object then return true.
    // otherwise, return false, then P9ViewAnimator delay the animation until you ready.
    func p9ViewAnimatorReady(forTargetName targetName: String) -> Bool {
        guard let targetView = targetView else {
            return false
        }
        return true
    }
    
    // called when p9ViewAnimatorReady(fortargetName:) confirm ready and key frame using target object want target view object.
    func p9ViewAnimatorView(forTargetName targetName: String) -> UIView? {
        guard let targetView = targetView else {
            return nil
        }
        return targetView
    }
    
    // called when p9ViewAnimatorReady(fortargetName:) confirm ready and key frame using target object want target frame.
    func p9ViewAnimatorFrame(forTargetName targetName: String) -> CGRect {
        guard let targetView = targetView else {
            return .zero
        }
        return targetView.frame
    }
}
```

When you ready, call action with passing target object that confirm P9ViewAnimatorTargetObjectProtocol, in this case view controller.  

```swift
P9ViewAnimator.default().action(anotherActorView, withScenario: scenario, delay: 0.0, targetObject: self, beginning: nil, completion: nil) 
```

If you use independent stage view and decoy view then, can make animation effect like some actor view on view controller to another view controller.  

# Frame animation key frame

P9ViewAnimator's animation based on keyframe, but you can make your own frame animation object and handling by confirm and implement P9ViewAnimatorTargetObjectProtocol.  
Make key frame for frame animation with its' target name, velociy and loop.

```swift
let targetAvatar = "avatar"

P9ViewAnimator.default().addKeyframeFrameAni(toScenario: scenario, after: 1.0, targetName: targetAvatar, velopcity: 1.0, loop: false, itprType: .linear)

extension SampleViewController: P9ViewAnimatorTargetOjectProtocol {

    // called when key frame using frame animation is ready
    func p9ViewAnimatorSetVelocity(_ relativeVelocity: CGFloat, forTargetName targetName: String) {
        if targetName == targetAvatar {
            playView.velocity = relativeVelocity
        }
    }

    // called when key frame using frame animation is ready
    func p9ViewAnimatorSetLoop(_ loop: Bool, forTargetName targetName: String) {
        if targetName == targetAvatar {
            playView.loop = loop
        }
    }

    // called when key frame using frame animation is ready
    func p9ViewAnimatorPlayTargetName(_ targetName: String) {
        if targetName == targetAvatar {
            playView.play()
        }
    }
}
```

# Action key frame

You can do some custom action when animating by using action key frame.

```swift
P9ViewAnimator.default().addKeyframeAction(toScenario: scenario, after: 0.0) { (actorView:UIView) in
    playSound()
}
```

# Decoy animation

P9ViewAnimator animate given actor view directly.  
But, you can do more animation effect by using decoy mechanism.

```swift
P9ViewAnimator.default().actionDecoy(actorView, onStageView: stageView, withScenario: scenario, delay: 0.0, targetObject: self, beginning: { (actorView:UIView?) in
    self.actorView.alpha = 0.0
}) { (actorView:UIView?) in
    self.actorView.alpha = 1.0
}
```

If you call 'actionDecoy' function rather then 'action' function, P9ViewAnimator take a snapshot of given actor view and make decoy view from it.  
And, use decoy view to animating on stage view.  
So, you can use trick like that, hide original actor view when animation began, animating with decoy view, and original actor view show after animation complete.  
If you have stage view on top layer any other view controllers, you can make animation like moving actor view from view controller to another view controller.  

You can pass the stage view when calling 'actionDecoy' function, but you also can set default stage view to P9ViewAnimator.
Here is simple example to set stage view.

```swift
var window: UIWindow?
var stageView: UIView = UIView(frame: .zero)

stageView.backgroundColor = .clear
stageView.layer.zPosition = .greatestFiniteMagnitude
stageView.frame = self.windows?.bounds ?? .zero
window.addSubview(stageView)

P9ViewAnimator.default().defaultStageView = stageView

// pass the nil for stage view then P9ViewAnimator use default stage view.
P9ViewAnimator.default().actionDecoy(actorView, onStageView: nil, withScenario: scenario, delay: 0.0, targetObject: self, beginning: { (actorView:UIView?) in
    self.actorView.alpha = 0.0
}) { (actorView:UIView?) in
    self.actorView.alpha = 1.0
}
```

# Handling animation

If you need to stop animation of some view, all 'stopAction' function for it.
Stop all animation under controled P9ViewAnimation by calling 'stopAllActions' function.

```swift
P9ViewAnimator.default().stopAction(actorView)
P9ViewAnimator.default().stopAllActions()
```

# Loading scenarios from file

P9ViewAnimator support json file format to load scenarios.

```json
{
   "<scenario name>" : [
        {
            "type": "frameAnimation" | "morph" | "alpha" | "translate" | "rotateX" | "rotateY" | "rotateZ" | "scale",
            "after": <time interval>,
            "target": "<target name>",
            "velocity": <velocity>,
            "loop": <bool flag>,
            "alpha": <alpha value>,
            "x": <x value>,
            "y": <y value>,
            "z": <z value>,
            "angle": <eulur angle>,
            "anchorX": <anchor x value>,
            "anchorY": <anchor y value>,
            "interpolation": "linear" | "easeIn" | "easeOut" | "easeInOut",
        },
        ...
   ],
   ...
}
```

```swift
if let resourcePath = Bundle.main.resourcePath {
    P9ViewAnimator.default().loadScenarios(fromFile: resourcePath+"/senarios.json", overwrite: true)
}
```

# License

MIT License, where applicable. http://en.wikipedia.org/wiki/MIT_License
