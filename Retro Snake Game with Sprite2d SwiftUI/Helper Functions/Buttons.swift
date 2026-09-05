
//
//  Buttons.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import SpriteKit

// Put the button-related functions inside GameScene.
// An extension lets us organize a large class into separate files.
extension GameScene {
    
    // Creates all of the buttons used by the game.
    func createButtons() {
        // Create the sound on/off button.
        createToggleSoundButton()
        
        // Create the volume minus and plus buttons.
        createVolumeButtons()
    }
    
    // Creates the button that turns game sound on and off.
    func createToggleSoundButton() {
        
        // Remove the old sound button before creating a new one.
        // This prevents "Sound On" and "Sound Off" from overlapping.
        soundButton?.removeFromParent()
        
        // The Simulator uses text instead of emoji.
        // This is useful when the Simulator cannot display the speaker emoji.
        #if targetEnvironment(simulator)
        let button = SKLabelNode(text: "Sound On")
        #else
        let button = SKLabelNode(text: "🔉")
        #endif
        
        // Set the font used by the button.
        button.fontName = fontName
        
        // Set the size of the button text.
        button.fontSize = 16
        
        // Set the button's position.
        // frame.maxX is the right edge of the scene.
        // frame.maxY is the top edge of the scene.
        button.position = CGPoint(
            x: frame.maxX - 55,
            y: frame.maxY - labelOffsetY
        )
        
        // A higher zPosition places the button in front of objects
        // with a lower zPosition.
        button.zPosition = 10
        
        // Give the button a name so we can identify it when tapped.
        button.name = "soundButton"
        
        // Add the button directly to the scene.
        addChild(button)
        
        // Save the button so we can change its text and position later.
        soundButton = button
    }
    
    // Creates the volume decrease and increase buttons.
    func createVolumeButtons() {
        
        // Create the minus button.
        let minus = SKLabelNode(text: "-")
        
        // Use the game's main font.
        minus.fontName = fontName
        
        // Make the minus button larger.
        minus.fontSize = 30
        
        // Position the minus button near the top-left.
        minus.position = CGPoint(
            x: 40,
            y: frame.maxY - labelOffsetY
        )
        
        // Make sure the button appears above the game objects.
        minus.zPosition = 10
        
        // Give the button a name so we can detect taps on it.
        minus.name = "minusButton"
        
        // Add the minus button to the game layer.
        gameLayer.addChild(minus)
        
        // Create the plus button.
        let plus = SKLabelNode(text: "+")
        
        // Use the game's main font.
        plus.fontName = fontName
        
        // Make the plus button larger.
        plus.fontSize = 30
        
        // Position the plus button next to the minus button.
        plus.position = CGPoint(
            x: 90,
            y: frame.maxY - labelOffsetY
        )
        
        // Make sure the button appears above the game objects.
        plus.zPosition = 10
        
        // Give the button a name so we can detect taps on it.
        plus.name = "plusButton"
        
        // Add the plus button to the game layer.
        gameLayer.addChild(plus)
    }
    
    // Updates the button positions when the scene size changes.
    // For example, this happens when an iPhone changes orientation.
    func updateButtonLayout() {
        
        // Move the sound button to the new top-right position.
        // The ? means this only runs if soundButton exists.
        soundButton?.position = CGPoint(
            x: frame.maxX - 55,
            y: frame.maxY - labelOffsetY
        )
        
        // Try to find the minus button inside the game layer.
        if let minus = gameLayer.childNode(withName: "minusButton") {
            
            // Move the minus button to its new position.
            minus.position = CGPoint(
                x: 40,
                y: frame.maxY - labelOffsetY
            )
        }
        
        // Try to find the plus button inside the game layer.
        if let plus = gameLayer.childNode(withName: "plusButton") {
            
            // Move the plus button to its new position.
            plus.position = CGPoint(
                x: 90,
                y: frame.maxY - labelOffsetY
            )
        }
    }
}

