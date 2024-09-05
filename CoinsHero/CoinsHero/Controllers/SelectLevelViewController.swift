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
    
    private struct Constants {
        static let changeLevelLabelTextColor: UIColor = UIColor(hexString: "FFCC00")
        static let levelButtonColor: UIColor = UIColor(hexString: "FFFD00")
        static let levelButtonBorderColor: CGColor = UIColor(hexString: "D8A024").cgColor
    }
    
    // MARK: - Properties
    
    private lazy var skView: SKView = {
        let skView = SKView(frame: self.view.bounds)
        skView.backgroundColor = .clear
        return skView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change level"
        label.font = UIFont(name: "Lepka", size: 40.0)
        label.textColor = Constants.changeLevelLabelTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var levelButtons: [UIButton] = []
    private let levelButtonSize: CGFloat = 50.0
    
    private var musicPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
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
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(self.skView)
        
        let scene = BackButtonScene(size: self.skView.bounds.size)
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFill
        
        let backgroundSprite = SKSpriteNode(imageNamed: "background")
        backgroundSprite.position = CGPoint(x: scene.size.width / 2.0, y: scene.size.height / 2.0)
        backgroundSprite.zPosition = -1.0
        backgroundSprite.size = scene.size
        scene.addChild(backgroundSprite)
        
        scene.backButtonActionHandler = { [weak self] in
            self?.backButtonTapped()
        }
        
        self.skView.presentScene(scene)
        
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
            
            if i != 1 {
                button.isEnabled = false
                button.alpha = 0.5
            }
            
            self.levelButtons.append(button)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 40.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        self.view.addSubview(stackView)
        self.view.addSubview(self.titleLabel) 
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -5.0),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40.0)
        ])
    }
    
    private func setupAudio() {
        guard let musicURL = Bundle.main.url(forResource: "menuMusic", withExtension: "mp3") else {
            print("Music file not found")
            return
        }

        do {
            self.musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            self.musicPlayer?.numberOfLoops = -1
            self.musicPlayer?.prepareToPlay()
            self.musicPlayer?.play()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Events
    
    @objc private func levelButtonTapped(_ sender: UIButton) {
        guard sender.tag == 1 else { return }
        
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
}
