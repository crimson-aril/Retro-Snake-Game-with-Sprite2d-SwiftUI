
//
//  Setup Game.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the classes and types used to build the game.
import SpriteKit


// MARK: - Game Setup

// This extension adds the setupGame() function to GameScene.
//
// Keeping setup code in a separate file makes the project easier
// to organize and understand.
extension GameScene {

    // Sets up a new game.
    //
    // This function is also used when restarting the game,
    // so it resets the previous game's state first.
    func setupGame() {

        // MARK: - Reset Values

        // Remove all nodes currently inside gameLayer.
        //
        // This clears the old snake, food, score, buttons,
        // and other game objects that were added to gameLayer.
        gameLayer.removeAllChildren()

        // Remove all snake parts from the snake array.
        //
        // The visual nodes were already removed above.
        // This clears the Swift array that keeps track of them.
        snake.removeAll()

        // Set the snake's starting direction.
        //
        // dx = 0 means no horizontal movement.
        // dy = 1 means movement upward.
        direction = .init(dx: 0, dy: 1)

        // Reset the player's score to zero.
        score = 0

        // Mark the game as active.
        //
        // false means the game is NOT over.
        isGameOver = false


        // MARK: - Setup Grid

        // Create the grid/background elements used by the game.
        setupGrid()


        // MARK: - Create Buttons

        // Create the sound and volume buttons.
        createButtons()


        // MARK: - Create Score

        // Create the score label and add it to the game.
        createScoreLabel()


        // MARK: - Create Snake Head

        // Calculate the center point of the game scene.
        //
        // size.width / 2 gives the horizontal center.
        // size.height / 2 gives the vertical center.
        let center = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )

        // Snap the center position to the game's grid.
        //
        // This makes sure the snake starts exactly on a grid cell
        // instead of possibly starting between cells.
        let startPosition = snapToGrid(center)

        // Create the snake's first part at the starting position.
        //
        // addSnakeHead() creates the head, gives it physics,
        // applies its shader, adds it to the scene,
        // and stores it in the snake array.
        addSnakeHead(at: startPosition)


        // MARK: - Spawn First Food

        // Create the first piece of food for the snake to eat.
        spawnFood()
    }
}
