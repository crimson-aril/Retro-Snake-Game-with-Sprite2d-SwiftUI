
//
//  GameScene.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import SpriteKit

// The main game scene.
// This class controls the Snake game and handles physics collisions.
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // A separate node used to hold most of the game's objects.
    // This makes it easier to clear and rebuild the game.
    var gameLayer = SKNode()
    
    // Stores all parts of the snake.
    // The first item in the array is the snake's head.
    var snake: [SKShapeNode] = []
    
    // Controls the direction in which the snake moves.
    // dx = horizontal movement, dy = vertical movement.
    var direction: CGVector = .init(dx: 1, dy: 0)
    
    // Keeps track of whether the game has ended.
    var isGameOver = false
    
    // The player's current score.
    var score = 0
    
    // Label used to display the score on the screen.
    var scoreLabel: SKLabelNode!
    
    // The size of one grid cell.
    // The snake moves one cell at a time.
    let cellSize: CGFloat = 20.0
    
    // Font used for the game's text and buttons.
    let fontName: String = "Menlo-Bold"
    
    // Controls how far the labels are placed from the top of the screen.
    let labelOffsetY: CGFloat = 100.0
    
    // The fruit that the snake needs to eat.
    var food: SKSpriteNode!
    
    // The button used to turn sound on and off.
    var soundButton: SKLabelNode!
    
    // Stores whether game sounds are currently enabled.
    var isSoundOn = true
    
    // The node responsible for playing background music.
    var backgroundMusic: SKAudioNode?
    
    // Name of the background music file.
    let musicName = ""
    
    // Current music volume.
    // Float values for volume normally range from 0.0 to 1.0.
    var volume: Float = 0.3
    
    // The sound effect played when the snake eats food.
    var eatSoundAction: SKAction!
    
    // Names of the fruit images that can randomly appear.
    let fruits = ["apple","banana","pineapple","strawberry","watermelon"]
    
    // Time between snake movements.
    // "private" means only this class can access the variable.
    private let moveInterval: TimeInterval = 0.15
    
    // Stores the time when the snake last moved.
    private var lastMoveTime: TimeInterval = 0
    
    // Called automatically when the scene is added to an SKView.
    // This is where the game is initially prepared.
    override func didMove(to view: SKView) {
        
        // Make the SpriteKit scene background transparent.
        self.backgroundColor = .clear
        
        // Add swipe controls for iPhone/iPad.
        createSwipeGestures(view: view)
        
        // Set up the physics system and collision detection.
        setupPhysics()
        
        // Add the main game layer to the scene.
        addChild(gameLayer)
        
        // Create the initial game objects.
        setupGame()
        
        // Load the eating sound in the background.
        // This helps avoid doing the work on the main UI thread.
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            // Safely get the GameScene object.
            // If it no longer exists, stop here.
            guard let self = self else { return }
            
            // Create the sound effect action.
            let action = SKAction.playSoundFileNamed(
                "eat.mp3",
                waitForCompletion: false
            )
            
            // SpriteKit UI-related work should happen on the main thread.
            DispatchQueue.main.async {
                self.eatSoundAction = action
                
                // Start setting up the background music.
                self.setupBackgroundMusic()
            }
        }
    }
    
    // Called repeatedly by SpriteKit while the game is running.
    // currentTime contains the current game time.
    override func update(_ currentTime: TimeInterval) {
        
        // Stop updating the snake if the game is over.
        guard !isGameOver else { return }
        
        // Check whether enough time has passed since the last movement.
        if currentTime - lastMoveTime > moveInterval {
            
            // Move the snake one grid cell.
            moveSnake()
            
            // Remember the time of this movement.
            lastMoveTime = currentTime
        }
    }
    
    // Called automatically by SpriteKit when two physics bodies begin touching.
    // This is how the game detects the snake hitting food, its body, or a wall.
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Get the snake's head.
        // If there is no head, there is nothing to check.
        guard let head = snake.first else { return }
        
        // Get the category of the first object involved in the collision.
        let bodyA = contact.bodyA.categoryBitMask
        
        // Get the category of the second object involved in the collision.
        let bodyB = contact.bodyB.categoryBitMask
        
        // Helper function that checks whether two physics categories collided.
        // The order of the two bodies does not matter.
        func isCollision(_ a: UInt32, _ b: UInt32) -> Bool {
            (bodyA == a && bodyB == b) || (bodyA == b && bodyB == a)
        }
        
        // Check whether the snake's head hit:
        // 1. Another part of the snake's body
        // 2. The wall
        let headBodyOrWallCollision = isCollision(
            PhysicsCategory.head, PhysicsCategory.body
        ) || isCollision(
            PhysicsCategory.head, PhysicsCategory.wall
        )
        
        // If the head hit the body or wall, end the game.
        if headBodyOrWallCollision {
            gameOver()
        }
        
        // Check whether the snake's head touched the food.
        let headFoodCollision = isCollision(
            PhysicsCategory.head,
            PhysicsCategory.food
        )
        
        if headFoodCollision {
            
            // Increase the score by one.
            score += 1
            
            // Update the score displayed on the screen.
            scoreLabel.text = "Score: \(score)"
            
            // Remove the old food and create new food.
            spawnFood()
            
            // Create the particle effect where the food was eaten.
            spawnParticle(at: head.position)
            
            // Change the head's color to green.
            head.fillColor = .green
            
            // Apply the green shader to the head.
            setBodyShader(part: head)
            
            // Add another snake part.
            addSnakeHead(at: computeNextHeadPosition())
            
            // Only play the eating sound when sound is enabled.
            if isSoundOn {
                run(eatSoundAction)
            }
        }
    }
    
    // Handles restarting the game after Game Over.
    private func handleGameRestart() {
        
        // Only restart if the game is currently over.
        if isGameOver {
            setupGame()
        }
    }
    
    // Checks whether the player tapped one of the game buttons.
    private func handleButtonTap(at location: CGPoint) {
        
        // Find the SpriteKit node located at the tap position.
        let node = atPoint(location)
        
        // Check the name of the node that was tapped.
        switch node.name {
            
        // Sound button was tapped.
        case "soundButton":
            
            // Change true to false, or false to true.
            isSoundOn.toggle()
            
            // On the Simulator, use text instead of emoji.
            // This avoids problems when the simulator cannot display emoji.
            #if targetEnvironment(simulator)
            soundButton.text = isSoundOn ? "Sound On" : "Sound Off"
            #else
            
            // On a real device, use the speaker emoji.
            soundButton.text = isSoundOn ? "🔉" : "🔇"
            #endif
            
            // Turn the music volume on or off.
            let targetVolume: Float = isSoundOn ? volume : 0.0
            
            // Smoothly change the background music volume.
            backgroundMusic?.run(
                SKAction.changeVolume(to: targetVolume, duration: 0.1)
            )
            
        // Minus button was tapped.
        case "minusButton":
            
            // Lower the volume by 0.1.
            // max() prevents the volume from going below 0.
            volume = max(0.0, volume - 0.1)
            
            // Apply the new volume.
            backgroundMusic?.run(
                SKAction.changeVolume(to: volume, duration: 0.1)
            )
            
        // Plus button was tapped.
        case "plusButton":
            
            // Increase the volume by 0.1.
            // min() prevents the volume from going above 1.0.
            volume = min(1.0, volume + 0.1)
            
            // Apply the new volume.
            backgroundMusic?.run(
                SKAction.changeVolume(to: volume, duration: 0.1)
            )
            
        // Nothing recognized was tapped.
        default:
            break
        }
    }
    
    // Called when the size of the scene changes.
    // This is especially useful when an iPhone changes orientation.
    override func didChangeSize(_ oldSize: CGSize) {
        
        // Rebuild the grid using the new scene size.
        setupGrid()
        
        // Move the buttons to their new positions.
        updateButtonLayout()
        
        // Move the score label to its new position.
        updateScoreLayout()
        
        // Rebuild the physics wall so it matches the new scene size.
        setupPhysics()
    }
    
    // iOS-specific touch controls.
    #if os(iOS)
    
    // Called when the player first touches the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If the game is over, touching the screen restarts it.
        handleGameRestart()
    }
    
    // Called when the player removes their finger from the screen.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touch.
        // If there isn't one, stop here.
        guard let touch = touches.first else { return }
        
        // Convert the touch location into the scene's coordinate system.
        let location = touch.location(in: self)
        
        // Check whether the player tapped a button.
        handleButtonTap(at: location)
    }
    
    // macOS-specific controls.
    #elseif os(macOS)
    
    // Called when the user clicks the mouse.
    override func mouseDown(with event: NSEvent) {
        
        // Restart the game if it is over.
        handleGameRestart()
        
        // Get the mouse position inside the scene.
        let location = event.location(in: self)
        
        // Check whether a button was clicked.
        handleButtonTap(at: location)
    }
    
    // Called when the user presses a keyboard key.
    override func keyDown(with event: NSEvent) {
        
        // Do not allow movement while the game is over.
        guard !isGameOver else { return }
        
        // Check which keyboard key was pressed.
        switch event.keyCode {
            
        // Up arrow key.
        case 126, 13:
            if direction.dy == 0 {
                direction = .init(dx: 0, dy: 1)
            }
            
        // Down arrow key.
        case 125, 1:
            if direction.dy == 0 {
                direction = .init(dx: 0, dy: -1)
            }
            
        // Left arrow key.
        case 123, 0:
            if direction.dx == 0 {
                direction = .init(dx: -1, dy: 0)
            }
            
        // Right arrow key.
        case 124, 2:
            if direction.dx == 0 {
                direction = .init(dx: 1, dy: 0)
            }
            
        // Ignore other keys.
        default:
            break
        }
    }
    
    #endif
}
