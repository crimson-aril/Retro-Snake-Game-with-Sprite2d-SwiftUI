//
//  Buttons.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the UI/game nodes we use for our buttons.
import SpriteKit

// MARK: - Button Creation
//
// This extension adds button-related functionality to GameScene.
//
// Keeping button code in its own file makes the project easier to
// understand and maintain.
//
// These aren't traditional SwiftUI Buttons.
// They are SKLabelNode objects that we treat as buttons by giving
// them names and detecting where the player clicks/taps.
extension GameScene {


// MARK: - Create All Buttons

// Creates all of the buttons used by the game.
//
// Instead of calling every button function separately from
// GameScene, we can simply call createButtons().
func createButtons() {

    // Create the button that turns sound on/off.
    createToggleSoundButton()

    // Create the volume decrease and increase buttons.
    createVolumeButtons()
}


// MARK: - Sound Toggle Button

// Creates the button used to turn game sound on and off.
func createToggleSoundButton() {

    // SKLabelNode displays text inside a SpriteKit scene.
    //
    // We use an emoji as the visual appearance of our button.
    let button = SKLabelNode(text: "🔊")


    // Use the font stored in our GameScene's fontName property.
    //
    // fontName was defined in GameScene.swift.
    button.fontName = fontName


    // Set the size of the button's text.
    button.fontSize = 24


    // Set the button's position inside the scene.
    //
    // frame.maxX gives us the right edge of the scene.
    //
    // Subtracting 40 moves the button 40 points to the left
    // from that edge.
    //
    // frame.maxY gives us the top edge of the scene.
    //
    // Subtracting labelOffsetY moves the button downward
    // from the top.
    button.position = CGPoint(
        x: frame.maxX - 40,
        y: frame.maxY - labelOffsetY
    )


    // zPosition controls the drawing order of nodes.
    //
    // A higher zPosition generally means the node is drawn
    // in front of nodes with a lower zPosition.
    //
    // We use 10 so our button appears above the game objects.
    button.zPosition = 10


    // Give the node a name.
    //
    // This name is important because handleButtonTap()
    // uses it to determine which button the player clicked.
    //
    // For example:
    //
    // node.name == "soundButton"
    //
    // tells our game that the sound button was clicked.
    button.name = "soundButton"


    // Add the button directly to the GameScene.
    //
    // Once a node is added to the scene, SpriteKit can display it.
    addChild(button)


    // Save a reference to this button.
    //
    // We need this later when we want to change its text from:
    //
    // 🔊
    //
    // to:
    //
    // 🔇
    soundButton = button
}


// MARK: - Volume Buttons

// Creates the buttons used to decrease and increase
// the background music volume.
func createVolumeButtons() {


    // MARK: Minus Button

    // Create a label containing the "-" symbol.
    //
    // We use an SKLabelNode instead of a traditional button
    // because this is a SpriteKit-based game interface.
    let minus = SKLabelNode(text: "-")


    // Set the font used by the button.
    minus.fontName = fontName


    // Make the minus symbol slightly larger.
    minus.fontSize = 30


    // Position the minus button near the upper-left corner.
    //
    // x: 40 means it is 40 points from the left edge.
    //
    // y: frame.maxY - labelOffsetY places it near the top.
    minus.position = CGPoint(
        x: 40,
        y: frame.maxY - labelOffsetY
    )


    // Put the button above most of the game content.
    minus.zPosition = 10


    // Give the button a unique name.
    //
    // handleButtonTap() will look for this name when the
    // player clicks/taps the button.
    minus.name = "minusButton"


    // Add the minus button to gameLayer.
    //
    // gameLayer is the container node used for our game objects.
    gameLayer.addChild(minus)


    // MARK: Plus Button

    // Create a label containing the "+" symbol.
    let plus = SKLabelNode(text: "+")


    // Use the same font as the minus button.
    plus.fontName = fontName


    // Set the text size.
    plus.fontSize = 30


    // Position the plus button next to the minus button.
    //
    // The minus button is at x = 40.
    // The plus button is at x = 90.
    //
    // This creates some horizontal space between them.
    plus.position = CGPoint(
        x: 90,
        y: frame.maxY - labelOffsetY
    )


    // Make sure the button appears above the game objects.
    plus.zPosition = 10


    // Give the button its own unique name.
    plus.name = "plusButton"


    // Add the plus button to the game layer.
    gameLayer.addChild(plus)
}

}
