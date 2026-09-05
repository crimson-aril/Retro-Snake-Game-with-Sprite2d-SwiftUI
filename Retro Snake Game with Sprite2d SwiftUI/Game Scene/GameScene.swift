//
//  GameScene.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import SpriteKit

// GameScene is the main scene where our Snake game lives.
//
// SKScene:
// Represents a 2D game world in SpriteKit.
//
// SKPhysicsContactDelegate:
// Allows this scene to receive notifications when two physics bodies
// collide with each other.
class GameScene: SKScene, SKPhysicsContactDelegate {

// A container node for the objects that belong to our game.
//
// SKNode is a basic node that can contain other nodes.
// Putting game objects inside gameLayer makes it easier to
// organize and reset the game.
var gameLayer = SKNode()

// Stores all the snake's body parts.
//
// [SKShapeNode] means this is an Array containing SKShapeNode objects.
// The first element (index 0) is the snake's head.
var snake: [SKShapeNode] = []

// Controls the direction in which the snake moves.
//
// CGVector contains an X and Y value.
//
// dx: 1, dy: 0 means:
// Move to the right.
//
// dx: 0, dy: 1 would mean:
// Move upward.
var direction: CGVector = .init(dx: 1, dy: 0)

// Keeps track of whether the game has ended.
//
// false = game is still running
// true  = game is over
var isGameOver = false

// Stores the player's current score.
var score = 0

// The label displayed on the screen that shows the score.
//
// The ! means this property is an implicitly unwrapped optional.
// We are telling Swift:
// "This will be assigned before I actually use it."
var scoreLabel: SKLabelNode!

// The size of one grid cell in the Snake game.
//
// Snake movement is based on a grid, so each movement is
// approximately one cellSize at a time.
let cellSize: CGFloat = 20.0

// Font used by our text labels.
let fontName: String = "Menlo-Bold"

// Controls how far the score label is positioned vertically.
let labelOffsetY: CGFloat = 100.0

// The fruit/food currently displayed in the game.
//
// SKSpriteNode is a node that displays an image.
var food: SKSpriteNode!

// Button used to turn sound on and off.
var soundButton: SKLabelNode!

// Controls whether sound effects are enabled.
//
// true  = sound is enabled
// false = sound is disabled
var isSoundOn = true

// Background music node.
//
// Optional (?) means there might not be background music loaded yet.
var backgroundMusic: SKAudioNode?

// Name of the music file used by the game.
let musicName = "good-times-halal-beats-vocals"

// Current music volume.
//
// Float is a floating-point number.
// 0.0 = silent
// 1.0 = maximum volume
var volume: Float = 0.3

// Sound effect that plays when the snake eats food.
//
// SKAction represents an action SpriteKit can perform.
var eatSoundAction: SKAction!

// Names of the different fruit images we can use.
//
// This is an Array of String values.
let fruits = [
    "apple",
    "banana",
    "pineapple",
    "strawberry",
    "watermelon"
]

// How often the snake should move.
//
// 0.15 seconds means the snake moves roughly every 150 milliseconds.
//
// private means this property can only be accessed from inside
// this GameScene class.
private let moveInterval: TimeInterval = 0.15

// Stores the time when the snake last moved.
//
// We use this together with moveInterval to control the
// snake's movement speed.
private var lastMoveTime: TimeInterval = 0


// MARK: - Scene Setup

// didMove(to:) is called automatically by SpriteKit when this
// scene has been presented by an SKView.
//
// This is a common place to perform initial game setup.
override func didMove(to view: SKView) {

    // Make the scene background transparent.
    //
    // This can be useful when the SwiftUI view behind the
    // SpriteKit scene provides the actual background.
    self.backgroundColor = .clear

    // Set up swipe gestures for controlling the snake.
    createSwipeGestures(view: view)

    // Configure the physics system.
    setupPhysics()

    // Add our gameLayer to the scene.
    //
    // A node does not appear in the scene until it is added
    // to another node that is already part of the scene.
    addChild(gameLayer)

    // Create the initial game objects.
    setupGame()


    // Load the sound effect away from the main thread.
    //
    // The main thread is responsible for UI and game interaction.
    // Doing potentially expensive work somewhere else can help
    // keep the game responsive.
    DispatchQueue.global(qos: .utility).async { [weak self] in

        // weak self prevents this background closure from keeping
        // GameScene alive unnecessarily.
        //
        // If GameScene no longer exists, simply stop here.
        guard let self = self else { return }

        // Create the action that will play our eating sound.
        //
        // waitForCompletion: false means SpriteKit does not need
        // to wait for the sound to finish before continuing.
        let action = SKAction.playSoundFileNamed(
            "eat.mp3",
            waitForCompletion: false
        )

        // Return to the main thread before updating game state.
        DispatchQueue.main.async {

            // Store the prepared sound action so we can use it later.
            self.eatSoundAction = action

            // Start setting up the background music.
            self.setupBackgroundMusic()
        }
    }
}


// MARK: - Game Loop

// SpriteKit automatically calls update() once per frame.
//
// currentTime is the amount of time associated with the current
// frame. We can use it to control things that should happen
// at a specific time interval.
override func update(_ currentTime: TimeInterval) {

    // If the game is over, don't move the snake.
    guard !isGameOver else { return }

    // Check whether enough time has passed since the last movement.
    //
    // Example:
    // currentTime - lastMoveTime
    // tells us how many seconds have passed since the snake moved.
    if currentTime - lastMoveTime > moveInterval {

        // Move the snake one grid step.
        moveSnake()

        // Remember the time of this movement.
        lastMoveTime = currentTime
    }
}


// MARK: - Physics Collision

// SpriteKit calls didBegin() automatically when two physics bodies
// begin touching each other.
//
// contact contains information about the two objects that collided.
func didBegin(_ contact: SKPhysicsContact) {

    // Make sure the snake has a head.
    //
    // snake.first returns the first element of the array.
    // Because it might not exist, it is optional.
    guard let head = snake.first else { return }

    // Get the collision category of each physics body.
    //
    // categoryBitMask tells us what type of object something is.
    let bodyA = contact.bodyA.categoryBitMask
    let bodyB = contact.bodyB.categoryBitMask


    // A small helper function that checks whether two collision
    // categories collided.
    //
    // We check both orders because SpriteKit could give us:
    //
    // head + food
    //
    // or:
    //
    // food + head
    //
    // Both should count as the same collision.
    func isCollision(_ a: UInt32, _ b: UInt32) -> Bool {

        return (bodyA == a && bodyB == b) ||
               (bodyA == b && bodyB == a)
    }


    // Check whether the snake's head hit:
    //
    // 1. Its own body
    // 2. A wall
    //
    // Either collision ends the game.
    let headBodyOrWallCollision = isCollision(
        PhysicsCategory.head,
        PhysicsCategory.body
    ) || isCollision(
        PhysicsCategory.head,
        PhysicsCategory.wall
    )


    // If the snake hit itself or a wall, end the game.
    if headBodyOrWallCollision {
        gameOver()
    }


    // Check whether the snake's head touched the food.
    let headFoodCollision = isCollision(
        PhysicsCategory.head,
        PhysicsCategory.food
    )


    // If the snake ate the food...
    if headFoodCollision {

        // Increase the player's score by 1.
        score += 1

        // Update the score label on the screen.
        //
        // \(score) is Swift string interpolation.
        // It inserts the value of score into the String.
        scoreLabel.text = "Score: \(score)"

        // Remove the old food and create new food.
        spawnFood()

        // Create a particle effect where the food was eaten.
        spawnParticle(at: head.position)

        // Temporarily change the head's fill color.
        head.fillColor = .green

        // Apply the shader effect to the snake head.
        setBodyShader(part: head)

        // Add another segment to the snake.
        //
        // computeNextHeadPosition() calculates where the new
        // segment should be placed.
        addSnakeHead(at: computeNextHeadPosition())


        // Play the eating sound if sound is enabled.
        if isSoundOn {
            run(eatSoundAction)
        }
    }
}


// MARK: - Cross-Platform Input Handling

// The actual restart logic is kept in its own function.
//
// This is useful because iOS and macOS use different input APIs,
// but both platforms can call this same function.
private func handleGameRestart() {

    // Only restart if the game has actually ended.
    if isGameOver {
        setupGame()
    }
}


// Handle buttons that the player clicks/taps.
//
// location tells us where the player interacted with the scene.
private func handleButtonTap(at location: CGPoint) {

    // Find the SpriteKit node located at the given point.
    let node = atPoint(location)


    // Check which button was clicked.
    //
    // node.name is a String identifying the node.
    switch node.name {

    // The sound button was clicked.
    case "soundButton":

        // Toggle the Boolean value.
        //
        // true becomes false.
        // false becomes true.
        isSoundOn.toggle()

        // Change the button icon based on the current state.
        soundButton.text = isSoundOn ? "🔊" : "🔇"


        // Choose the target volume.
        //
        // If sound is on, use the current volume.
        // If sound is off, use 0.0.
        let targetVolume: Float = isSoundOn ? volume : 0.0

        // Smoothly change the background music volume.
        backgroundMusic?.run(
            SKAction.changeVolume(
                to: targetVolume,
                duration: 0.1
            )
        )


    // The minus volume button was clicked.
    case "minusButton":

        // Decrease the volume by 0.1.
        //
        // max() prevents the value from going below 0.0.
        volume = max(0.0, volume - 0.1)

        // Apply the new volume.
        backgroundMusic?.run(
            SKAction.changeVolume(
                to: volume,
                duration: 0.1
            )
        )


    // The plus volume button was clicked.
    case "plusButton":

        // Increase the volume by 0.1.
        //
        // min() prevents the value from going above 1.0.
        volume = min(1.0, volume + 0.1)

        // Apply the new volume.
        backgroundMusic?.run(
            SKAction.changeVolume(
                to: volume,
                duration: 0.1
            )
        )


    // The player clicked/tapped something that isn't one
    // of our buttons.
    default:
        break
    }
}


// MARK: - iOS Input

// This code is compiled only when building for iOS.
#if os(iOS)

// Called when the player touches the screen.
override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {

    // Check whether the game should restart.
    handleGameRestart()
}


// Called when the player removes their finger from the screen.
override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {

    // Get the first touch.
    //
    // A Set can contain multiple touches, so first is optional.
    guard let touch = touches.first else { return }

    // Convert the touch location into a position inside
    // our SpriteKit scene.
    let location = touch.location(in: self)

    // Check whether the player tapped one of our buttons.
    handleButtonTap(at: location)
}


// MARK: - macOS Input

// This code is compiled only when building for macOS.
#elseif os(macOS)

// Called when the user clicks the mouse.
override func mouseDown(with event: NSEvent) {

    // Check whether the game should restart.
    handleGameRestart()

    // Get the mouse position inside the SpriteKit scene.
    let location = event.location(in: self)

    // Check whether the user clicked one of our buttons.
    handleButtonTap(at: location)
}


// Called when the user presses a keyboard key.
override func keyDown(with event: NSEvent) {

    // Don't allow movement when the game is over.
    guard !isGameOver else { return }


    // Check which keyboard key was pressed.
    //
    // keyCode is a numeric code representing the physical key.
    //
    // We support both:
    // Arrow keys
    // WASD keys
    switch event.keyCode {


    // Up Arrow or W
    case 126, 13:

        // Only allow moving vertically if we're not already
        // moving vertically.
        //
        // This prevents the snake from immediately reversing
        // direction into itself.
        if direction.dy == 0 {
            direction = .init(dx: 0, dy: 1)
        }


    // Down Arrow or S
    case 125, 1:

        if direction.dy == 0 {
            direction = .init(dx: 0, dy: -1)
        }


    // Left Arrow or A
    case 123, 0:

        if direction.dx == 0 {
            direction = .init(dx: -1, dy: 0)
        }


    // Right Arrow or D
    case 124, 2:

        if direction.dx == 0 {
            direction = .init(dx: 1, dy: 0)
        }


    // Any other key.
    default:
        break
    }
}

// End of the macOS-only code.
#endif

}
