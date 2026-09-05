
//
//  Spawn Food.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the nodes, physics bodies, actions,
// and other game features used here.
import SpriteKit


// MARK: - Spawn Food

// This extension adds food-related functionality to GameScene.
//
// Keeping food spawning in its own file makes the project
// easier to organize.
extension GameScene {

    // Creates a new piece of food at a random position
    // inside the playable area.
    func spawnFood() {

        // Remove the previous food from the scene if one exists.
        //
        // The "?" means this is optional chaining.
        // If food is nil, nothing happens.
        food?.removeFromParent()


        // MARK: - Define Margins

        // Keep the food at least two grid cells away
        // from the left and right edges.
        let horizontalMargin: CGFloat = cellSize * 2

        // Keep the food away from the bottom edge.
        let bottomMargin = cellSize * 2

        // Keep extra space at the top for the score and buttons.
        let topMargin = cellSize * 4


        // MARK: - Compute Playable Area

        // Calculate the leftmost position where food can appear.
        let minX = frame.minX + horizontalMargin

        // Calculate the rightmost position where food can appear.
        let maxX = frame.maxX - horizontalMargin

        // Calculate the lowest position where food can appear.
        let minY = frame.minY + bottomMargin

        // Calculate the highest position where food can appear.
        let maxY = frame.maxY - topMargin


        // MARK: - Convert Playable Area Into Grid Coordinates

        // Calculate how many complete grid cells fit horizontally
        // inside the playable area.
        //
        // Int() converts the result from CGFloat to an integer
        // because we need a whole number of columns.
        let cols = Int((maxX - minX) / cellSize)

        // Calculate how many complete grid cells fit vertically.
        let rows = Int((maxY - minY) / cellSize)

        // Make sure there is at least one column and one row.
        //
        // If either value is zero or negative, there is nowhere
        // to safely place the food, so the function stops.
        guard cols > 0, rows > 0 else { return }

        // Choose a random column.
        //
        // 0..<cols creates a range from 0 up to, but not including,
        // cols.
        let randCol = Int.random(in: 0..<cols)

        // Choose a random row using the same idea.
        let randRow = Int.random(in: 0..<rows)


        // MARK: - Snap Grid to Center

        // Convert the randomly selected grid column into an
        // actual x position in the SpriteKit scene.
        //
        // cellSize / 2 moves the food to the center of its
        // grid cell instead of placing it on the cell's edge.
        let x = minX + CGFloat(randCol) * cellSize + cellSize / 2

        // Convert the randomly selected grid row into an
        // actual y position and place the food in the center
        // of that grid cell.
        let y = minY + CGFloat(randRow) * cellSize + cellSize / 2


        // MARK: - Create Fruit Sprite

        // Choose a random fruit name from the fruits array.
        //
        // randomElement() can return nil if the array is empty.
        // The ?? operator provides "apple" as a fallback.
        let name = fruits.randomElement() ?? "apple"

        // Create an SKSpriteNode using the selected image.
        //
        // The image must be included in the project's asset
        // resources with the matching name.
        food = SKSpriteNode(imageNamed: name)

        // Put the food at the randomly calculated position.
        food.position = CGPoint(x: x, y: y)

        // Make the food the same size as one grid cell.
        food.size = CGSize(width: cellSize, height: cellSize)


        // MARK: - Physics

        // Give the food a physics body.
        //
        // The physics body is smaller than the visible fruit.
        // This makes the collision area half the cell size
        // in both dimensions.
        food.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: cellSize / 2,
                height: cellSize / 2
            )
        )

        // Make the physics body participate in the physics system.
        food.physicsBody?.isDynamic = true

        // Identify this physics body as food.
        //
        // GameScene's collision code can use this category
        // to determine that the snake has eaten food.
        food.physicsBody?.categoryBitMask = PhysicsCategory.food

        // Prevent the food from physically pushing or blocking
        // other physics bodies.
        //
        // The food can still be detected through contact testing.
        food.physicsBody?.collisionBitMask = 0


        // MARK: - Breathing Animation

        // Create an animation that gradually makes the food larger.
        let scaleUp = SKAction.scale(to: 1.5, duration: 1)

        // Create an animation that gradually makes the food smaller.
        let scaleDown = SKAction.scale(to: 0.8, duration: 1)

        // Put the two animations together in sequence:
        //
        // 1. Grow to 1.5× size
        // 2. Shrink to 0.8× size
        //
        // repeatForever makes this sequence continue indefinitely.
        let pulse = SKAction.repeatForever(
            .sequence([scaleUp, scaleDown])
        )

        // Start the breathing/pulsing animation on the food.
        food.run(pulse)

        // Finally, add the food sprite to gameLayer so it becomes
        // visible in the game.
        gameLayer.addChild(food)
    }
}
