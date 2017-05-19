//
//  EarthViewController.swift
//  Sample
//
//  Created by Tae Hyun Na on 2017. 3. 13.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit
import SpriteKit

class EarthViewController: UIViewController, P9ViewAnimatorTargetObjectProtocol {

    @IBOutlet var kingghidorahImageView: UIImageView!
    @IBOutlet var godzillaImageView: UIImageView!
    @IBOutlet var roarButton: UIButton!
    @IBOutlet var backToVenusButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var ryuView: SKView!
    
    lazy var ryuScene:SimpleFrameAnimationScene = SimpleFrameAnimationScene()
    var hideKingghidorahViewWhenReady:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let frames = ["0.0:0.0:0.2:1.0",
                      "0.16:0.0:0.2:1.0",
                      "0.32:0.0:0.2:1.0",
                      "0.48:0.0:0.2:1.0",
                      "0.64:0.0:0.2:1.0",
                      "0.8:0.0:0.2:1.0",
                      "0.0:0.0:0.2:1.0"];
        if( self.ryuScene.load(UIImage(named:"ryuSouryuken"), frames: frames, timePerFrame: 0.1) == true ) {
            //self.ryuView.showsFPS = true
            self.ryuView.presentScene(self.ryuScene)
        }
        
        if self.hideKingghidorahViewWhenReady == true {
            self.kingghidorahImageView.alpha = 0.0
            self.hideKingghidorahViewWhenReady = false
            self.roarButton.isEnabled = false
            self.backToVenusButton.isEnabled = false
        }
        
        P9ViewDragger.default().trackingView(self.ryuView, parameters: nil, ready: nil, trackingHandler: nil, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func roarButtonTouchUpInside(_ sender: UIButton) {
        
        P9ViewAnimator.default().action(self.kingghidorahImageView, withScenario: roarScenarioName, delay: 0.0, targetObject: nil, beginning: { (actorView:UIView?) in
            self.roarButton.isEnabled = false
            self.backToVenusButton.isEnabled = false
        }, completion: nil)
        
        P9ViewAnimator.default().action(self.godzillaImageView, withScenario: roarScenarioName, delay: 1.0, targetObject: nil, beginning: nil) { (actorView:UIView?) in
            self.roarButton.isEnabled = true
            self.backToVenusButton.isEnabled = true
        }
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: UIButton) {
        
        P9ViewAnimator.default().action(self.ryuView, withScenario: souryukenScenarioName, delay: 0.0, targetObject: self, beginning: { (actorView:UIView?) in
            self.playButton.isEnabled = false
        }) { (actorView:UIView?) in
            self.playButton.isEnabled = true
        }
    }
    
    @IBAction func backToVenusButtonTouchUpInside(_ sender: UIButton) {
        
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count > 1 {
                if let venusVC = navigationController.viewControllers[navigationController.viewControllers.count-2] as? VenusViewController {
                    P9ViewAnimator.default().actionDecoy(self.kingghidorahImageView, onStageView: nil, withScenario: flyToTheVenusScenarioName, delay: 0.0, targetObject: venusVC, beginning: { (actorView:UIView?) in
                        self.kingghidorahImageView.alpha = 0.0
                    }) { (actorView:UIView?) in
                        self.kingghidorahImageView.alpha = 1.0
                    }
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
    func p9ViewAnimatorScenarioStarted(_ scenarioName: String) {

        if (scenarioName == flyToTheEarthScenarioName) || (scenarioName == flyToTheVenusScenarioName) {
            if( self.kingghidorahImageView != nil ) {
                self.kingghidorahImageView.alpha = 0.0
                self.roarButton.isEnabled = false
                self.backToVenusButton.isEnabled = false
            } else {
                self.hideKingghidorahViewWhenReady = true
            }
        }
    }
    
    func p9ViewAnimatorScenarioEnded(_ scenarioName: String) {
        
        if (scenarioName == flyToTheEarthScenarioName) || (scenarioName == flyToTheVenusScenarioName) {
            self.kingghidorahImageView.alpha = 1.0
            self.roarButton.isEnabled = true
            self.backToVenusButton.isEnabled = true
        }
    }
    
    func p9ViewAnimatorReady(forTargetName targetName: String) -> Bool {
        
        switch( targetName ) {
            case kighidorahTargetName :
                if self.kingghidorahImageView != nil {
                    return true
                }
            case ryuTargetName :
                if self.ryuView != nil {
                    return true
                }
            default :
                break
        }
        return false
    }
    
    func p9ViewAnimatorView(forTargetName targetName: String) -> UIView? {
        
        switch( targetName ) {
        case kighidorahTargetName :
            if self.kingghidorahImageView != nil {
                return self.kingghidorahImageView
            }
        case ryuTargetName :
            if self.ryuView != nil {
                return self.ryuView
            }
        default :
            break
        }
        return nil
    }
    
    func p9ViewAnimatorFrame(forTargetName targetName: String) -> CGRect {
        
        switch( targetName ) {
        case kighidorahTargetName :
            if self.kingghidorahImageView != nil {
                return self.kingghidorahImageView.frame
            }
        case ryuTargetName :
            if self.ryuView != nil {
                return self.ryuView.frame
            }
        default :
            break
        }
        return .zero
    }
    
    func p9ViewAnimatorSetVelocity(_ relativeVelocity: CGFloat, forTargetName targetName: String) {
        
        if targetName == ryuTargetName {
            self.ryuScene.setRelativeVelocity(relativeVelocity)
        }
    }
    
    func p9ViewAnimatorPlayTargetName(_ targetName: String) {
        
        if targetName == ryuTargetName {
            self.ryuScene.play()
        }
    }
}

