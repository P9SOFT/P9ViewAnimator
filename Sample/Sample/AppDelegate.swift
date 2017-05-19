//
//  AppDelegate.swift
//  Sample
//
//  Created by Tae Hyun Na on 2017. 3. 13.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var stageView: UIView = UIView(frame: .zero)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.stageView.backgroundColor = .clear
        self.stageView.layer.zPosition = .greatestFiniteMagnitude
        if let bounds = self.window?.bounds {
            self.stageView.frame = bounds
        }
        self.window?.addSubview(stageView)
        
        P9ViewAnimator.default().defaultStageView = self.stageView
        
        P9ViewAnimator.default().createScenario(danceScenarioName)
        P9ViewAnimator.default().addKeyframeScale(toScenario: danceScenarioName, after: 1.0, x: 2.0, y: 2.0, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: danceScenarioName, after: 0.0, x: 140, y: 100, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeRotateZ(toScenario: danceScenarioName, after: 1.0, angle: 360.0, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: danceScenarioName, after: 0.0, x: -100, y: 100, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeScale(toScenario: danceScenarioName, after: 1.0, x: 0.5, y: 0.5, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: danceScenarioName, after: 0.0, x: -40.0, y: -200, itprType: .easeInOut)
        P9ViewAnimator.default().addKeyframeRotateZ(toScenario: danceScenarioName, after: 0.5, angle: 90.0, anchorX: 1.0, anchorY: 1.0, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeRotateZ(toScenario: danceScenarioName, after: 0.5, angle: 90.0, anchorX: 1.0, anchorY: 0.0, itprType: .linear)
        P9ViewAnimator.default().addKeyframeRotateZ(toScenario: danceScenarioName, after: 0.5, angle: 90.0, anchorX: 0.0, anchorY: 0.0, itprType: .linear)
        P9ViewAnimator.default().addKeyframeRotateZ(toScenario: danceScenarioName, after: 0.5, angle: 90.0, anchorX: 0.0, anchorY: 1.0, itprType: .easeOut)
        P9ViewAnimator.default().addKeyframeScale(toScenario: danceScenarioName, after: 0.5, x: 2.0, y: 2.0, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: danceScenarioName, after: 0.0, x: -96.0, y: 0.0, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeAlpha(toScenario: danceScenarioName, after: 0.0, alpha: 0.2, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeScale(toScenario: danceScenarioName, after: 0.5, x: 0.5, y: 0.5, itprType: .easeOut)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: danceScenarioName, after: 0.0, x: -96.0, y: 0.0, itprType: .easeOut)
        P9ViewAnimator.default().addKeyframeAlpha(toScenario: danceScenarioName, after: 0.0, alpha: 1.0, itprType: .easeOut)
        
        P9ViewAnimator.default().createScenario(flyToTheEarthScenarioName)
        P9ViewAnimator.default().addKeyframeScale(toScenario: flyToTheEarthScenarioName, after: 1.0, x: 1.6, y: 1.6, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: flyToTheEarthScenarioName, after: 0.0, x: 0.0, y: 100.0, itprType: .easeIn)
        P9ViewAnimator.default().addKeyframeMorph(toScenario: flyToTheEarthScenarioName, after: 1.0, targetName: kighidorahTargetName, itprType: .linear)
        
        P9ViewAnimator.default().createScenario(souryukenScenarioName)
        P9ViewAnimator.default().addKeyframeFrameAni(toScenario: souryukenScenarioName, after: 0.2, targetName: ryuTargetName, velopcity: 1.0, loop: false, itprType: .linear)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: souryukenScenarioName, after: 0.0, x: 50.0, y: -50.0, itprType: .linear)
        P9ViewAnimator.default().addKeyframeTranslate(toScenario: souryukenScenarioName, after: 0.4, x: 0.0, y: 50.0, itprType: .linear)
        
        if let resourcePath = Bundle.main.resourcePath {
            P9ViewAnimator.default().loadScenarios(fromFile: resourcePath+"/senarios.json", overwrite: true)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

