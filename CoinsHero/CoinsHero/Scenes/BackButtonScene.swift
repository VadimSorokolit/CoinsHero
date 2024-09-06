//
//  BackButtonScene.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 05.09.2024.
//
    
import SpriteKit

class BackButtonScene: SKScene {
    
    // MARK: - Properties
    
    // The back button node to be displayed in the scene
    private var backButtonNode: SKSpriteNode!
    
    // A closure to handle back button action
    var backButtonActionHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Set up the back button when the scene is presented
        self.setupBackButton()
    }
    
    // MARK: - Methods
    
    private func setupBackButton() {
        // Create a texture for the back button
        let backTexture = SKTexture(imageNamed: "backButton")
        
        // Initialize the back button node with the texture
        self.backButtonNode = SKSpriteNode(texture: backTexture)
        self.backButtonNode.position = CGPoint(x: 50.0, y: self.size.height - 50.0)
        self.backButtonNode.size = CGSize(width: 30.0, height: 30.0)
        self.backButtonNode.name = "backButton"
        self.addChild(self.backButtonNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touch events
        guard let location = touches.first?.location(in: self) else { return }
        let touchedNodes = nodes(at: location) // Get nodes at the touch location
        
        // Check if the back button was touched
        if touchedNodes.contains(self.backButtonNode) {
            // Call the back button action handler if defined
            self.backButtonActionHandler?()
        }
    }
    
}
