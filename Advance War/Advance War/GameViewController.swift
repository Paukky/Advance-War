//
//  GameViewController.swift
//  Advance War
//
//  Created by Ly Paul H. on 4/6/18.
//  Copyright © 2018 Ly Paul H. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    var GoogleBannerView: GADBannerView!
    
    @IBAction func playButton() {
        let scene = GameScene(size: CGSize (width:2048, height:1536))
        let skView = SKView()
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Present the scene
        skView.presentScene(scene)
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        self.view = skView
    }
    
    override func viewDidLoad() {
        let view = UIView()
        view.sizeToFit()
        
        let play = UIButton(type: .roundedRect) as UIButton
        play.setTitle("Play", for: .normal)
        play.setTitleColor(UIColor.white, for: .normal)
        play.frame = CGRect(x: 120, y: 120, width:150, height:150)
        play.backgroundColor = UIColor.darkGray
        play.addTarget(self ,action : #selector(playButton), for: .touchUpInside)
        view.addSubview(play)
        // Load Google Test Ad
        GoogleBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        GoogleBannerView.rootViewController = self
        addBannerViewToView(GoogleBannerView)
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GoogleBannerView.load(request)
        self.view = view
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
