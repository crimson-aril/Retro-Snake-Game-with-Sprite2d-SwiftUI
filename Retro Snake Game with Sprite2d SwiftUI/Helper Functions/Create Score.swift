
//
//  Create Score.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import SpriteKit

// MARK: - Score Label

// An extension lets us add new functionality to GameScene
// without putting all of the code inside the main GameScene class.
//
// This keeps the project organized by separating the score-related
// code into its own file.
extension GameScene {

    // Creates the score text that appears on the screen.
    func createScoreLabel() {

        // SKLabelNode is a SpriteKit node used to display text.
        //
        // We start the label with "Score: 0" because the player
        // has not eaten any food when a new game begins.
        let label = SKLabelNode(text: "Score: 0")

        // Use the font that we defined in GameScene.
        // In your project, this is "Menlo-Bold".
        label.fontName = fontName

        // Set the size of the score text.
        label.fontSize = 20

        // Set the position of the score label.
        label.position = CGPoint(

            // frame.midX is the horizontal center of the game scene.
            // This places the score in the middle from left to right.
            x: frame.midX,

            // frame.maxY is the top edge of the game scene.
            //
            // We subtract labelOffsetY so that the score is moved
            // down from the very top of the screen.
            y: frame.maxY - labelOffsetY
        )

        // Save this label in the scoreLabel property of GameScene.
        //
        // This is important because we can later change its text
        // when the player's score increases.
        //
        // For example:
        // scoreLabel.text = "Score: 5"
        scoreLabel = label

        // Add the score label to gameLayer so SpriteKit
        // can display it in the game.
        gameLayer.addChild(scoreLabel)
    }
}

