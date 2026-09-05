
//
//  Game Over.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the game and scene-related classes we use here.
import SpriteKit


// MARK: - Game Over

// Add game-over functionality to the existing GameScene class.
//
// Using an extension keeps the project organized by allowing
// game-over code to live in its own file.
extension GameScene {

    // This function is called when the snake hits something
    // that causes the game to end.
    func gameOver() {

        // Print a message to Xcode's console.
        //
        // This is useful while developing because it lets us
        // confirm that the game-over function was called.
        print("Game over!")

        // Change the game state to indicate that the game is over.
        //
        // Other parts of GameScene can check this value to stop
        // the snake from moving or ignore further input.
        isGameOver = true

        // Create a text label displaying the game-over message.
        //
        // "\n" creates a new line, so the text becomes:
        //
        // Game Over
        // Tap to Restart
        let gameOverLabel = SKLabelNode(text: "Game Over\nTap to Restart")

        // Set the font used by the game-over message.
        gameOverLabel.fontName = "Copperplate-Bold"

        // Set the size of the text.
        gameOverLabel.fontSize = 28

        // Tell SpriteKit that this label contains two lines.
        gameOverLabel.numberOfLines = 2

        // Center the text horizontally around its position.
        //
        // Without this, the label's position would be based
        // on its default horizontal alignment.
        gameOverLabel.horizontalAlignmentMode = .center

        // Position the game-over message in the center of the screen.
        gameOverLabel.position = CGPoint(

            // size.width / 2 gives us the horizontal center.
            x: size.width / 2,

            // size.height / 2 gives us the vertical center.
            y: size.height / 2
        )

        // Add the game-over label to gameLayer so it becomes
        // visible in the game.
        gameLayer.addChild(gameOverLabel)
    }
}
