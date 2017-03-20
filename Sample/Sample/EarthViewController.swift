//
//  EarthViewController.swift
//  Sample
//
//  Created by Tae Hyun Na on 2017. 3. 13.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit

class EarthViewController: UIViewController, P9ViewAnimatorTargetObjectProtocol {

    @IBOutlet var kingghidorahImageView: UIImageView!
    @IBOutlet var godzillaImageView: UIImageView!
    @IBOutlet var roarButton: UIButton!
    @IBOutlet var backToVenusButton: UIButton!
    
    var hideKingghidorahViewWhenReady:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.hideKingghidorahViewWhenReady == true {
            self.kingghidorahImageView.alpha = 0.0
            self.hideKingghidorahViewWhenReady = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func roarButtonTouchUpInside(_ sender: UIButton) {
        
        P9ViewAnimator.default().action(self.kingghidorahImageView, withScenario: fightScenarioName, delay: 0.0, targetObject: nil, beginning: nil, completion: nil)
        P9ViewAnimator.default().action(self.godzillaImageView, withScenario: fightScenarioName, delay: 1.0, targetObject: nil, beginning: { (actorView:UIView?) in
            self.roarButton.isEnabled = false
        }) { (actorView:UIView?) in
            self.roarButton.isEnabled = true
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
    
    func p9ViewAnimatorStarted() {
        
        if( self.kingghidorahImageView != nil ) {
            self.kingghidorahImageView.alpha = 0.0
        } else {
            self.hideKingghidorahViewWhenReady = true
        }
    }
    
    func p9ViewAnimatorEnded() {
        
        self.kingghidorahImageView.alpha = 1.0
    }
    
    func p9ViewAnimatorReady(forTargetName targetName: String!) -> Bool {
        
        if targetName == kighidorahTargetName {
            if self.kingghidorahImageView != nil {
                return true
            }
        }
        return false
    }
    
    func p9ViewAnimatorView(forTargetName targetName: String!) -> UIView? {
        
        if targetName == kighidorahTargetName {
            return self.kingghidorahImageView
        }
        return nil
    }
    
    func p9ViewAnimatorFrame(forTargetName targetName: String!) -> CGRect {
        
        if targetName == kighidorahTargetName {
            return self.kingghidorahImageView.frame
        }
        return .zero
    }

}

