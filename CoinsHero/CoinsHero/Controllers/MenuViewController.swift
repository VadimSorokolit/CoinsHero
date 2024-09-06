//
//  MenuViewController.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 05.09.2024.
//
    
import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    
    // MARK: - Objects
    
    // Constants for button colors
    private struct Constants {
        static let buttonsTextColor: UIColor = UIColor(hexString: "FFCC00")
        static let buttonsBorderColor: CGColor = UIColor.black.cgColor
    }
    
    // MARK: - Properties
    
    // Button to start the game
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Game", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(self.startGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Button to open options
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Options", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(self.openOptions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Button to show high scores
    private lazy var highScoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("High Score", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(self.showHighScore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // SKView to display SpriteKit content
    private lazy var skView: SKView = {
        let skView = SKView(frame: self.view.bounds)
        return skView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
    }
    
    // Adding SKView and buttons to the view hierarchy
    private func setupViews() {
        self.view.addSubview(self.skView)
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.optionsButton)
        self.view.addSubview(self.highScoreButton)
        
        // Setting up the SpriteKit scene
        let scene = SKScene(size: self.skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Adding a background image to the scene
        let background = SKSpriteNode(imageNamed: "background")
        let xPostion = scene.size.width / 2.0
        let yPosition = scene.size.height / 2.0
        background.position = CGPoint(x: xPostion , y: yPosition)
        background.size = scene.size
        scene.addChild(background)
        
        // Presenting the scene in the SKView
        self.skView.presentScene(scene)
        
        // Setting up constraints for buttons
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60.0),
            self.optionsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.optionsButton.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 20.0),
            self.highScoreButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.highScoreButton.topAnchor.constraint(equalTo: self.optionsButton.bottomAnchor, constant: 20.0)
        ])
    }
    
    // MARK: - Events
    
    @objc private func startGame() {
        let selectLevelViewController = SelectLevelViewController()
        navigationController?.pushViewController(selectLevelViewController, animated: true)
    }
    
    @objc private func openOptions() {}
    
    @objc private func showHighScore() {}
    
}
