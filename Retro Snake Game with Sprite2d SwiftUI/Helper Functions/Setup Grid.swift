
//
//  Setup Grid.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

import Foundation
import SpriteKit

// An extension keeps the grid-related code separate from the main GameScene class.
extension GameScene {
    
    // Creates the grid that appears in the background of the game.
    func setupGrid() {
        
        // Remove the old grid before creating a new one.
        // This is important when the screen size changes, such as during rotation.
        gameLayer.childNode(withName: "gridNode")?.removeFromParent()
        
        // Create a node that will contain all of the grid lines.
        let gridNode = SKNode()
        
        // Give the node a name so we can find and remove it later.
        gridNode.name = "gridNode"
        
        // Put the grid behind the other game objects.
        // A lower zPosition appears behind objects with a higher zPosition.
        gridNode.zPosition = -1
        
        // Create the vertical grid lines.
        // stride() repeatedly increases x by cellSize until it reaches the scene width.
        for x in stride(from: 0, to: size.width, by: cellSize) {
            
            // Create an empty path that will describe the line.
            let path = CGMutablePath()
            
            // Set the starting point at the bottom of the scene.
            path.move(to: CGPoint(x: x, y: 0))
            
            // Draw the line from the bottom to the top of the scene.
            path.addLine(to: CGPoint(x: x, y: size.height))
            
            // Create a visible SpriteKit shape from the path.
            let line = SKShapeNode(path: path)
            
            // Make the grid line white.
            line.strokeColor = .white
            
            // Make the line partially transparent so it does not overpower the game.
            line.alpha = 0.3
            
            // Set the thickness of the grid line.
            line.lineWidth = 1
            
            // Add this vertical line to the grid node.
            gridNode.addChild(line)
        }
        
        // Create the horizontal grid lines.
        // stride() increases y by cellSize until it reaches the scene height.
        for y in stride(from: 0, to: size.height, by: cellSize) {
            
            // Create an empty path for the horizontal line.
            let path = CGMutablePath()
            
            // Set the starting point at the left side of the scene.
            path.move(to: CGPoint(x: 0, y: y))
            
            // Draw the line from the left side to the right side.
            path.addLine(to: CGPoint(x: size.width, y: y))
            
            // Create a visible SpriteKit shape from the path.
            let line = SKShapeNode(path: path)
            
            // Make the grid line white.
            line.strokeColor = .white
            
            // Make the line partially transparent.
            line.alpha = 0.3
            
            // Set the thickness of the grid line.
            line.lineWidth = 1
            
            // Add this horizontal line to the grid node.
            gridNode.addChild(line)
        }
        
        // Add the completed grid to the game layer so it appears on screen.
        gameLayer.addChild(gridNode)
    }
}

