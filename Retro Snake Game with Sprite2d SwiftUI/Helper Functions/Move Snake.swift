
//
//  Move Snake.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Foundation provides basic Swift functionality.
import Foundation

// SpriteKit provides CGPoint, SKShapeNode, and other game-related types.
import SpriteKit


// MARK: - Snake Movement

// This extension adds movement-related functions to GameScene.
//
// Keeping movement in its own file makes the project easier to
// understand and maintain.
extension GameScene {

    // Calculates where the snake's next head should be placed.
    //
    // This function does not actually move the snake.
    // It only calculates and returns the next position.
    func computeNextHeadPosition() -> CGPoint {

        // Start with the center of the game scene.
        //
        // This is used as a fallback position if the snake does
        // not have a head yet.
        let center = snapToGrid(CGPoint(
            x: size.width / 2,
            y: size.height / 2
        ))

        // Try to get the first element of the snake array.
        //
        // snake.first returns the first snake part, which represents
        // the head of the snake.
        //
        // If the array is empty, there is no head to move from.
        guard let head = snake.first else {

            // If there is no head, return the center of the screen.
            return center
        }

        // Calculate the next position of the head.
        //
        // direction.dx and direction.dy tell us which direction
        // the snake is currently moving.
        //
        // Multiplying the direction by cellSize makes the snake
        // move exactly one grid cell at a time.
        return CGPoint(
            x: head.position.x + direction.dx * cellSize,
            y: head.position.y + direction.dy * cellSize
        )
    }


    // Moves the snake forward by one grid cell.
    func moveSnake() {

        // First calculate where the new head should go.
        let newHeadPos = computeNextHeadPosition()

        // Create a new snake head at the calculated position.
        //
        // addSnakeHead() also adds the new part to the beginning
        // of the snake array.
        addSnakeHead(at: newHeadPos)

        // Remove the last part of the snake array.
        //
        // The last part is the tail because the head is stored
        // at index 0.
        let tail = snake.removeLast()

        // Remove the old tail node from the SpriteKit scene.
        //
        // Removing it from the array alone would not remove
        // the visual object from the screen.
        tail.removeFromParent()


        // MARK: - Update Body

        // Make sure the snake has more than one part before
        // trying to update a body segment.
        //
        // snake[1] is the second part of the snake, immediately
        // behind the head.
        if snake.count > 1 {

            // Get the previous head.
            //
            // After creating a new head, the old head moves to
            // index 1 and becomes part of the body.
            let prevHead = snake[1]

            // Change the old head's shader so it uses the
            // green body appearance instead of the red head
            // appearance.
            setBodyShader(part: prevHead)

            // Set the body segment's base color to green.
            prevHead.fillColor = .green

            // Change its physics category from "head" to "body".
            //
            // This is important because the collision system needs
            // to know that this part is now a body segment.
            prevHead.physicsBody?.categoryBitMask = PhysicsCategory.body
        }
    }
}

