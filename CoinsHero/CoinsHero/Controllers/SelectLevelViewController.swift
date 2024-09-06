//
//  SelectLevelViewController.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 05.09.2024.
//
    
import UIKit
import SpriteKit
import AVFoundation

class SelectLevelViewController: UIViewController {
    
    // MARK: - Objects
    
    // Colors for labels and buttons
    private struct Constants {
        static let changeLevelLabelTextColor: UIColor = UIColor(hexString: "FFCC00")
        static let levelButtonColor: UIColor = UIColor(hexString: "FFFD00")
        static let levelButtonBorderColor: CGColor = UIColor(hexString: "D8A024").cgColor
    }
    
    // MARK: - Properties
    
    // SKView to display the SpriteKit scene
    private lazy var skView: SKView = {
        let skView = SKView(frame: self.view.bounds)
        skView.backgroundColor = .clear 
        return skView
    }()
    
    // Label for the title of the view controller
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change level"
        label.font = UIFont(name: "Lepka", size: 40.0)
        label.textColor = Constants.changeLevelLabelTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Array to hold level buttons
    private var levelButtons: [UIButton] = []
    
    // Size of the level buttons
    private let levelButtonSize: CGFloat = 50.0
    
    // Audio player for background music
    private var musicPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // Stop music when the view is about to disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.musicPlayer?.stop()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
        self.setupAudio()
    }
    
    private func setupViews() {
        // Hide the back button in the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Add SKView to the view hierarchy
        self.view.addSubview(self.skView)
        
        // Create and configure the SpriteKit scene
        let scene = BackButtonScene(size: self.skView.bounds.size)
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFill
        
        // Set up the background sprite
        let backgroundSprite = SKSpriteNode(imageNamed: "background")
        backgroundSprite.position = CGPoint(x: scene.size.width / 2.0, y: scene.size.height / 2.0)
        backgroundSprite.zPosition = -1.0
        backgroundSprite.size = scene.size
        scene.addChild(backgroundSprite)
        
        // Set up the back button action handler
        scene.backButtonActionHandler = { [weak self] in
            self?.backButtonTapped()
        }
        
        // Present the scene in the SKView
        self.skView.presentScene(scene)
        
        // Create level buttons
        for i in 1...9 {
            let button = UIButton(type: .system)
            button.setTitle("\(i)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Lepka", size: 16.0)
            button.backgroundColor = Constants.levelButtonColor
            button.layer.cornerRadius = 10.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = Constants.levelButtonBorderColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.addTarget(self, action: #selector(self.levelButtonTapped(_:)), for: .touchUpInside)
            
            // Disable and set alpha for buttons other than the first one
            if i != 1 {
                button.isEnabled = false
                button.alpha = 0.5
            }
            
            self.levelButtons.append(button)
        }
        
        // Create stack views to arrange level buttons in a grid
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 40.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add buttons to rows within the stack view
        for row in 0..<3 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .center
            rowStackView.spacing = 30.0
            rowStackView.distribution = .equalSpacing
            
            for col in 0..<3 {
                let buttonIndex = row * 3 + col
                let button = self.levelButtons[buttonIndex]
                
                rowStackView.addArrangedSubview(button)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: self.levelButtonSize),
                    button.heightAnchor.constraint(equalToConstant: self.levelButtonSize)
                ])
            }
            stackView.addArrangedSubview(rowStackView)
        }
        
        // Add views to the main view
        self.view.addSubview(stackView)
        self.view.addSubview(self.titleLabel)
        
        // Set up layout constraints
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -5.0),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40.0)
        ])
    }
    
    private func setupAudio() {
        // Load and set up background music
        guard let musicURL = Bundle.main.url(forResource: "menuMusic", withExtension: "mp3") else {
            print("Music file not found")
            return
        }
        
        do {
            self.musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            self.musicPlayer?.numberOfLoops = -1 // Loop indefinitely
            self.musicPlayer?.prepareToPlay()
            self.musicPlayer?.play()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    // Handle back button tap by popping the current view controller
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Events
    
    // Handle level button tap. For now, only level 1 is functional
    @objc private func levelButtonTapped(_ sender: UIButton) {
        guard sender.tag == 1 else { return }
        
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
}
