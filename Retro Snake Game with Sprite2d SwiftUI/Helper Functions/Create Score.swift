//
//  Create Score.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import SpriteKit

// An extension keeps the score-related code separate from the main GameScene class.
// This makes the project easier to organize and understand.
extension GameScene {
    
    // Creates the label that displays the player's score.
    func createScoreLabel() {
        
        // Create a SpriteKit text label and give it the starting text.
        let label = SKLabelNode(text: "Score: 0")
        
        // Use the font defined in GameScene.
        label.fontName = fontName
        
        // Set the size of the score text.
        label.fontSize = 20
        
        // Position the score near the top-center of the screen.
        // frame.midX gives us the horizontal center of the scene.
        // frame.maxY gives us the top edge of the scene.
        label.position = CGPoint(
            x: frame.midX,
            y: frame.maxY - labelOffsetY
        )
        
        // Save the label in scoreLabel so other parts of the game
        // can update its text when the player earns points.
        scoreLabel = label
        
        // Add the score label to the game layer so it appears on screen.
        gameLayer.addChild(scoreLabel)
    }
    
    // Updates the score label's position when the scene size changes.
    // This is useful when the device changes orientation.
    func updateScoreLayout() {
        
        // Move the score back to the horizontal center of the new scene size.
        // The ? means this code only runs if scoreLabel actually exists.
        scoreLabel?.position = CGPoint(
            x: frame.midX,
            y: frame.maxY - labelOffsetY
        )
    }
}

