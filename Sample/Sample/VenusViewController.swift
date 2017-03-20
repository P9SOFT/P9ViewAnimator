//
//  ViewController.swift
//  Sample
//
//  Created by Tae Hyun Na on 2017. 3. 13.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit

class VenusViewController: UIViewController, P9ViewAnimatorTargetObjectProtocol {

    @IBOutlet var kingghidorahImageView: UIImageView!
    @IBOutlet var danceButton: UIButton!
    @IBOutlet var flyToEarthButton: UIButton!
    
    let flyToTheEarthIdentifier = "flyToTheEarth"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == flyToTheEarthIdentifier {
                if let earthVC = segue.destination as? EarthViewController {
                    P9ViewAnimator.default().actionDecoy(self.kingghidorahImageView, onStageView: nil, withScenario: flyToTheEarthScenarioName, delay: 0.0, targetObject: earthVC, beginning: { (actorView:UIView?) in
                        self.kingghidorahImageView.alpha = 0.0
                    }) { (actorView:UIView?) in
                        self.kingghidorahImageView.alpha = 1.0
                    }
                }
            }
        }
    }
    
    @IBAction func danceButtonTouchUpInside(_ sender: UIButton) {
        
        P9ViewAnimator.default().action(self.kingghidorahImageView, withScenario: danceScenarioName, delay: 0.0, targetObject: nil, beginning: { (actorView:UIView?) in
            self.danceButton.isEnabled = false
        }) { (actorView:UIView?) in
            self.danceButton.isEnabled = true
        }
    }
    
    @IBAction func flyToEarthButtonTouchUpInside(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: flyToTheEarthIdentifier, sender: self)
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

