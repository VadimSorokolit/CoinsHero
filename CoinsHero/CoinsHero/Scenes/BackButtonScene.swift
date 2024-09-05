//
//  BackButtonScene.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 05.09.2024.
//
    
import SpriteKit

class BackButtonScene: SKScene {
    
    // MARK: Properties
    
    var backButtonNode: SKSpriteNode!
    var backButtonAction: (() -> Void)?
    
    // MARK: Lifecycle
    
    override func didMove(to view: SKView) {
        self.setupBackButton()
    }
    
    // MARK: Methods
    
    private func setupBackButton() {
        let backTexture = SKTexture(imageNamed: "backButton")
        self.backButtonNode = SKSpriteNode(texture: backTexture)
        self.backButtonNode.position = CGPoint(x: 50.0, y: self.size.height - 50.0)
        self.backButtonNode.size = CGSize(width: 30.0, height: 30.0)
        self.backButtonNode.name = "backButton"
        self.addChild(self.backButtonNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let touchedNodes = nodes(at: location)
        
        if touchedNodes.contains(self.backButtonNode) {
            self.backButtonAction?()
        }
    }
    
}
