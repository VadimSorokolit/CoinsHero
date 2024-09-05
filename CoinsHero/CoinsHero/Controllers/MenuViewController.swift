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
    
    private struct Constants {
        static let buttonsTextColor: UIColor = .systemYellow
        static let buttonsBorderColor: CGColor = UIColor.black.cgColor
    }
    
    // MARK: - Properties
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Game", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Options", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(self.openOptions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var highScoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("High Score", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lepka", size: 40.0)
        button.setTitleColor(Constants.buttonsTextColor, for: .normal)
        button.addTarget(self, action: #selector(self.showHighScore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    private func setupViews() {
        self.view.addSubview(self.skView)
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.optionsButton)
        self.view.addSubview(self.highScoreButton)
        
        let scene = SKScene(size: self.skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        let background = SKSpriteNode(imageNamed: "background")
        let xPostion = scene.size.width / 2.0
        let yPosition = scene.size.height / 2.0
        background.position = CGPoint(x: xPostion , y: yPosition)
        background.size = scene.size
        scene.addChild(background)
        
        self.skView.presentScene(scene)
        
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60.0),
            self.optionsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.optionsButton.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 20.0),
            self.highScoreButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.highScoreButton.topAnchor.constraint(equalTo: self.optionsButton.bottomAnchor, constant: 20.0)
        ])    }

    // MARK: - Events
    
    @objc func startGame() {
        let selectLevelViewController = SelectLevelViewController()
        navigationController?.pushViewController(selectLevelViewController, animated: true)
    }
    
    @objc func openOptions() {
    }
    
    @objc func showHighScore() {
 
    }
    
}
