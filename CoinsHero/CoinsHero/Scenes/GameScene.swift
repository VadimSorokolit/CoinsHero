//
//  GameScene.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 04.09.2024.
//
    
import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    // MARK: Objects
    
    private struct Constants {
        static let scoreLabelColor: UIColor = UIColor(hexString: "FFCC00")
    }
    
    // MARK: - Properties
    
    private var ground: SKSpriteNode!
    private var hero: SKSpriteNode!
    private var lives: [SKSpriteNode] = []
    private var coins: [SKSpriteNode] = []
    private var rocks: [SKSpriteNode] = []
    
    private var scoreLabel: SKLabelNode!
    
    private var coinSpawnTimer: Timer?
    private var rockSpawnTimer: Timer?
    
    private var score: Int = 0
    private var maxScore: Int = 20
    private let coinSpawnHeight: CGFloat = 100.0
    private let heroJumpHeight: CGFloat = 300.0
    private var isJumping: Bool  = false
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    var backButtonTappedHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupNodes()
        self.playBackgroundMusic()
    }
    
    private func setupNodes() {
        self.createBackground()
        self.createGround()
        self.createHero()
        self.addSpriteToScene()
        self.addLives()
        self.setupScoreLabel()
        self.startSpawningCoins()
        self.startSpawningRocks()
    }
    
    private func addSpriteToScene() {
        let spriteTexture = SKTexture(imageNamed: "backButton")
        
        let sprite = SKSpriteNode(texture: spriteTexture)
        sprite.name = "backButton"
        sprite.position = CGPoint(x: self.size.width / 2.0 - 1000.0, y: self.size.height / 2.0 + 400.0)
        sprite.zPosition = 100.0
        sprite.size = CGSize(width: spriteTexture.size().width * 0.3, height: spriteTexture.size().height * 0.3)
        
        let hitArea = SKSpriteNode(color: .clear, size: CGSize(width: sprite.size.width * 2.0, height: sprite.size.height * 2))
        hitArea.position = sprite.position
        hitArea.zPosition = sprite.zPosition
        hitArea.name = "backButtonHitArea"
        
        self.addChild(hitArea)
        self.addChild(sprite)
    }
    
    private func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        let moveDuration: TimeInterval = 4.0
        let numberOfBackgrounds = 4
        
        for i in 0..<numberOfBackgrounds {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.anchorPoint = .zero
            background.position = CGPoint(x: CGFloat(i) * backgroundTexture.size().width, y: .zero)
            background.zPosition = -1.0
            background.size = CGSize(width: backgroundTexture.size().width, height: self.size.height)
            
            let moveBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: .zero, duration: moveDuration)
            let resetBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: .zero, duration: .zero)
            let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, resetBackground]))
            
            background.run(moveBackgroundForever)
            self.addChild(background)
        }
    }

    private func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        let groundWidth = groundTexture.size().width
        
        for i in 0...4 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.name = "Ground"
            ground.anchorPoint = .zero
            let xPosition = CGFloat(i) * groundWidth
            ground.position = CGPoint(x: xPosition , y: .zero)
            ground.zPosition = 1.0
            ground.xScale = 2.2
            ground.yScale = 2.2
            
            let moveGround = SKAction.moveBy(x: -groundWidth, y: .zero, duration: 10.0)
            let resetGround = SKAction.moveBy(x: groundWidth, y: .zero, duration: .zero)
            let moveGroundForever = SKAction.repeatForever(SKAction.sequence([moveGround, resetGround]))
            
            ground.run(moveGroundForever)
            self.addChild(ground)
        }
        
        self.ground = SKSpriteNode(texture: groundTexture)
        self.ground.position = .zero
        self.ground.size = CGSize(width: groundWidth * 5.0, height: groundTexture.size().height * 2.2)
        self.addChild(self.ground)
    }
    
    private func createHero() {
        guard let ground = self.ground else {
            print("Error: Ground is not initialized")
            return
        }
        
        self.hero = SKSpriteNode(imageNamed: "hero")
        self.hero.name = "Hero"
        self.hero.zPosition = 5.0
        self.hero.setScale(0.25)
        let xPosition = (self.frame.width / 2.0) - 600.0
        let yPosition = ground.frame.height + (self.hero.frame.height / 2.0)
        self.hero.position = CGPoint(x: xPosition, y: yPosition)
        
        let heroRunTextures = (0...5).map({ SKTexture(imageNamed: "run\($0)") })
        let runAction = SKAction.animate(with: heroRunTextures, timePerFrame: 0.2)
        let runForever = SKAction.repeatForever(runAction)
        self.hero.run(runForever)
        self.addChild(self.hero)
    }
    
    private func addLives() {
        let healthTexture = SKTexture(imageNamed: "health")
        let spacing: CGFloat = 90.0
        let additionalOffset: CGFloat = 1400.0
        
        for i in 0..<3 {
            let health = SKSpriteNode(texture: healthTexture)
            health.setScale(0.2)
            
            let xPosition = additionalOffset + health.size.width / 2 + CGFloat(i) * (health.size.width * 0.2 + spacing)
            health.position = CGPoint(x: xPosition, y: size.height - health.size.height / 2.0 - 330.0)
            health.zPosition = 8.0
            
            self.addChild(health)
            self.lives.append(health)
        }
    }
    
    private func setupScoreLabel() {
        self.scoreLabel = SKLabelNode(fontNamed: "Lepka")
        self.scoreLabel.text = "Score: \(self.score) / \(self.maxScore)"
        self.scoreLabel.fontColor = Constants.scoreLabelColor
        self.scoreLabel.fontSize = 66.0
        self.scoreLabel.zPosition = 10.0
        
        let livesHeight = self.lives.first?.size.height ?? .zero
        let xOffset: CGFloat = 240.0
        let yOffset: CGFloat = -90.0
        
        self.scoreLabel.position = CGPoint(x: (self.lives.last?.position.x ?? .zero) + (self.lives.last?.size.width ?? .zero) / 2.0 + xOffset,
                                           y: size.height - livesHeight / 2.0 - 444.0 - yOffset)
        self.addChild(self.scoreLabel)
    }
    
    private func spawnCoin() {
        let coinTexture = SKTexture(imageNamed: "coin")
        let coin = SKSpriteNode(texture: coinTexture)
        coin.setScale(0.15)
        
        let xPosition = self.size.width + coin.size.width / 2.0
        let yPosition = self.ground.position.y + self.ground.size.height + coin.size.height / 2.0 + CGFloat.random(in: self.coinSpawnHeight...(self.coinSpawnHeight + self.heroJumpHeight))
        
        coin.position = CGPoint(x: xPosition, y: yPosition)
        coin.zPosition = 5.0
        
        let moveAction = SKAction.moveBy(x: -self.size.width - coin.size.width, y: .zero, duration: 10.0)
        let removeAction = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveAction, removeAction])
        coin.run(moveAndRemove)
        
        self.addChild(coin)
        self.coins.append(coin)
    }
    
    private func spawnRock() {
        let rockTexture = SKTexture(imageNamed: "rock")
        let rock = SKSpriteNode(texture: rockTexture)
        rock.setScale(0.2)
        
        let xPosition = self.size.width + rock.size.width / 2.0
        let yPosition = self.ground.position.y + self.ground.size.height + rock.size.height / 2.0 - 10.0
        
        rock.position = CGPoint(x: xPosition, y: yPosition)
        rock.zPosition = 6.0
        
        let moveAction = SKAction.moveBy(x: -self.size.width - rock.size.width, y: .zero, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveAction, removeAction])
        rock.run(moveAndRemove)
        
        self.addChild(rock)
        self.rocks.append(rock)
    }
    
    private func startSpawningCoins() {
        self.coinSpawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.spawnCoin()
        }
    }
    
    private func startSpawningRocks() {
        self.rockSpawnTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self?.spawnRock()
        }
    }
    
    private func jumpHero() {
        guard !self.isJumping else { return }
        self.isJumping = true
        
        let jumpHeight: CGFloat = 300.0
        let jumpDuration: TimeInterval = 0.3
        
        let jumpUp = SKAction.moveBy(x: .zero, y: jumpHeight, duration: jumpDuration)
        let jumpDown = SKAction.moveBy(x: .zero, y: -jumpHeight, duration: jumpDuration)
        let setJumpingFalse = SKAction.run { [weak self] in
            self?.isJumping = false
        }
        
        let jumpSequence = SKAction.sequence([jumpUp, jumpDown, setJumpingFalse])
        
        self.hero.run(jumpSequence)
    }
    
    private func checkForCollisions() {
        for coin in self.coins {
            if self.hero.frame.intersects(coin.frame) {
                let coinSoundAction = SKAction.playSoundFileNamed("coinRecieved.mp3", waitForCompletion: false)
                
                self.run(coinSoundAction)
                
                coin.removeFromParent()
                
                self.coins.removeAll { $0 == coin }
                self.score += 1
                self.scoreLabel.text = "Score: \(score) / \(self.maxScore)"
                
                if self.score >= self.maxScore {
                    self.winGame()
                }
            }
        }
        
        for rock in self.rocks {
            if self.hero.frame.intersects(rock.frame) {
                let rockSoundAction = SKAction.playSoundFileNamed("rockHite", waitForCompletion: false)
                
                self.run(rockSoundAction)

                rock.removeFromParent()
                
                self.rocks.removeAll { $0 == rock }
                
                if !lives.isEmpty {
                    let life = self.lives.removeFirst()
                    life.removeFromParent()
                    
                    let changeColorAction = SKAction.colorize(with: .red, colorBlendFactor: 0.5, duration: 0.1)
                    let waitAction = SKAction.wait(forDuration: 0.4)
                    let restoreColorAction = SKAction.colorize(withColorBlendFactor: .zero, duration: 0.1)
                    let colorChangeSequence = SKAction.sequence([changeColorAction, waitAction, restoreColorAction])
                    
                    self.hero.run(colorChangeSequence)
                    
                    if self.lives.isEmpty {
                        self.showGameOver()
                    }
                }
            }
        }
    }
    
    private func winGame() {
        self.coinSpawnTimer?.invalidate()
        self.rockSpawnTimer?.invalidate()
        
        for coin in self.coins {
            coin.removeFromParent()
        }
        self.coins.removeAll()
        
        for rock in self.rocks {
            rock.removeFromParent()
        }
        self.rocks.removeAll()
        
        let winSprite = SKSpriteNode(imageNamed: "youWin")
        winSprite.scale(to: CGSize(width: 400.0, height: 200.0))
        winSprite.zPosition = 20.0
        let xPosition = self.size.width / 2.0
        let yPosition = self.size.height / 2.0
        winSprite.position = CGPoint(x: xPosition, y: yPosition)
        
        self.addChild(winSprite)
        
        let winSoundAction = SKAction.playSoundFileNamed("youWin.mp3", waitForCompletion: false)
        self.run(winSoundAction)
        
        let pauseAction = SKAction.run { [weak self] in
            self?.isPaused = true
        }
        self.run(pauseAction)
        self.backgroundMusicPlayer?.stop()
    }
    
    private func showGameOver() {
        self.coinSpawnTimer?.invalidate()
        self.rockSpawnTimer?.invalidate()
        
        for coin in self.coins {
            coin.removeFromParent()
        }
        self.coins.removeAll()
        
        for rock in self.rocks {
            rock.removeFromParent()
        }
        self.rocks.removeAll()
        
        let xPositionHero = (self.frame.width / 2.0) - 600.0
        let yPositionHero = ground.frame.height + (self.hero.frame.height / 2.0 - 16.0)
        self.hero.position = CGPoint(x: xPositionHero, y: yPositionHero)
        
        self.hero.zRotation = 3.14
        self.hero.zPosition = 2.0
        
        let gameOverSprite = SKSpriteNode(imageNamed: "gameOver")
        gameOverSprite.setScale(0.15)
        gameOverSprite.zPosition = 20.0
        let xPosition = self.size.width / 2.0
        let yPosition = self.size.height / 2.0
        gameOverSprite.position = CGPoint(x: xPosition, y: yPosition)
        
        self.addChild(gameOverSprite)
        
        let gameOverSoundAction = SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false)
        self.run(gameOverSoundAction)
        
        let pauseAction = SKAction.run { [weak self] in
            self?.isPaused = true
        }
        self.run(pauseAction)
        self.backgroundMusicPlayer?.stop()
    }
    
    private func playBackgroundMusic() {
        guard let musicURL = Bundle.main.url(forResource: "gameMusic", withExtension: "mp3") else {
            print("Background music file not found")
            return
        }
        
        do {
            self.backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            self.backgroundMusicPlayer?.numberOfLoops = -1
            self.backgroundMusicPlayer?.play()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "backButton" || node.name == "backButtonHitArea" {
                self.backButtonTappedHandler?()
            } else {
                self.jumpHero()
            }
        }
    }
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        self.checkForCollisions()
    }
    
}
