
//
//  Setup Grid.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Foundation provides basic Swift functionality and types.
import Foundation

// SpriteKit provides the game nodes and drawing tools
// used to create the grid.
import SpriteKit


// MARK: - Grid Setup

// Add grid-related functionality to GameScene.
//
// An extension allows us to keep the grid code in its own file
// instead of putting everything into GameScene.swift.
extension GameScene {

    // Creates the grid that appears behind the snake.
    func setupGrid() {

        // SKNode is a container node.
        //
        // We can add all of the grid lines to this node,
        // then add the whole grid to the game at once.
        let gridNode = SKNode()

        // Put the grid behind the other game objects.
        //
        // Nodes with a lower zPosition are drawn behind nodes
        // with a higher zPosition.
        gridNode.zPosition = -1


        // MARK: - Vertical Lines

        // Create vertical lines across the screen.
        //
        // stride(from:to:by:) generates values starting at 0
        // and increasing by cellSize until reaching size.width.
        //
        // For example, if cellSize is 20:
        //
        // 0, 20, 40, 60, 80, ...
        for x in stride(from: 0, to: size.width, by: cellSize) {

            // CGMutablePath is used to create a drawable path.
            let path = CGMutablePath()

            // Start the path at the bottom of the screen.
            path.move(to: CGPoint(x: x, y: 0))

            // Draw the path upward to the top of the screen.
            //
            // Because the x value stays the same, this creates
            // a vertical line.
            path.addLine(to: CGPoint(x: x, y: size.height))

            // Create an SKShapeNode using the path we just created.
            //
            // SKShapeNode can draw lines, shapes, and paths.
            let line = SKShapeNode(path: path)

            // Make the line white.
            line.strokeColor = .white

            // Make the line partially transparent.
            //
            // 0.0 = completely invisible
            // 1.0 = completely opaque
            line.alpha = 0.3

            // Set the thickness of the line.
            line.lineWidth = 1

            // Add the vertical line to the grid container.
            gridNode.addChild(line)
        }


        // MARK: - Horizontal Lines

        // Create horizontal lines across the screen.
        //
        // The loop works the same way as the vertical-line loop,
        // but this time we increase the y coordinate.
        for y in stride(from: 0, to: size.height, by: cellSize) {

            // Create a new path for this horizontal line.
            let path = CGMutablePath()

            // Start at the left side of the screen.
            path.move(to: CGPoint(x: 0, y: y))

            // Draw the path to the right side of the screen.
            //
            // Because the y value stays the same, this creates
            // a horizontal line.
            path.addLine(to: CGPoint(x: size.width, y: y))

            // Turn the path into an SKShapeNode so SpriteKit
            // can display it.
            let line = SKShapeNode(path: path)

            // Make the line white.
            line.strokeColor = .white

            // Make it partially transparent.
            line.alpha = 0.3

            // Set the line thickness.
            line.lineWidth = 1

            // Add the horizontal line to the grid container.
            gridNode.addChild(line)
        }


        // Add the completed grid to the game's main layer.
        //
        // At this point all vertical and horizontal lines are
        // inside gridNode, so adding gridNode displays the entire grid.
        gameLayer.addChild(gridNode)
    }
}
