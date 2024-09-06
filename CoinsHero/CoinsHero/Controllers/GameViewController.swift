//
//  GameViewController.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 04.09.2024.
//
    
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
    }
    
    private func setupViews() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let skView = SKView(frame: self.view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(skView)
        
        let sceneSize = CGSize(width: 2248.0, height: 1536.0)
        let scene = GameScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        
        scene.backButtonTappedHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
