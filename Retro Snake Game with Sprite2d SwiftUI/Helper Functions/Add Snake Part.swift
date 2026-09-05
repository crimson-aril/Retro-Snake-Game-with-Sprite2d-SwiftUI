//
//  Add Snake Part.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the 2D game objects and rendering tools
// used by our Snake game.
import SpriteKit

// MARK: - GameScene Extension
//
// An extension lets us add more functionality to GameScene
// without putting every function inside GameScene.swift.
//
// This is useful for keeping a large game organized.
//
// For example:
// GameScene.swift       → main game logic
// Add Snake Part.swift  → snake-part creation and shaders
extension GameScene {


// MARK: - Add Snake Head

// Creates a new snake segment and adds it to the beginning
// of the snake array.
//
// The name "addSnakeHead" is used because the newly created
// part becomes the first element of the snake array.
//
// position tells us where the new part should appear.
func addSnakeHead(at position: CGPoint) {

    // Create a square using SKShapeNode.
    //
    // rectOf defines the width and height of the rectangle.
    //
    // cellSize is our grid size, so every snake segment
    // has the same size as one grid cell.
    //
    // cornerRadius: 4 slightly rounds the corners.
    let part = SKShapeNode(
        rectOf: CGSize(
            width: cellSize,
            height: cellSize
        ),
        cornerRadius: 4
    )


    // Give the snake part a red fill color.
    //
    // fillColor controls the inside of an SKShapeNode.
    part.fillColor = .red


    // Remove the outline around the shape.
    //
    // strokeColor controls the border/outline.
    //
    // .clear means completely transparent.
    part.strokeColor = .clear


    // Make sure the part is positioned exactly on our
    // game's grid.
    //
    // snapToGrid() converts an arbitrary CGPoint into
    // the center of the nearest grid cell.
    part.position = snapToGrid(position)


    // MARK: Physics Body

    // Give the snake part a physics body.
    //
    // A physics body allows SpriteKit's physics system
    // to detect collisions involving this object.
    //
    // We make the physics body slightly smaller than the
    // visual square (90% of cellSize).
    //
    // This gives the snake a little tolerance around its edges.
    part.physicsBody = SKPhysicsBody(
        rectangleOf: CGSize(
            width: 0.9 * cellSize,
            height: 0.9 * cellSize
        )
    )


    // isDynamic controls whether the physics engine should
    // simulate movement/forces for this body.
    //
    // true means the physics body participates dynamically
    // in the physics simulation.
    part.physicsBody?.isDynamic = true


    // Tell SpriteKit what kind of object this physics body is.
    //
    // PhysicsCategory.head is a custom collision category
    // defined elsewhere in the project.
    //
    // This allows didBegin(_:) in GameScene to recognize
    // that this object is the snake's head.
    part.physicsBody?.categoryBitMask = PhysicsCategory.head


    // Tell SpriteKit which types of objects we want to
    // receive collision notifications for.
    //
    // The | operator combines multiple bit masks.
    //
    // So the head should detect collisions with:
    //
    // PhysicsCategory.food
    // OR
    // PhysicsCategory.body
    part.physicsBody?.contactTestBitMask =
        PhysicsCategory.food | PhysicsCategory.body


    // collisionBitMask controls physical collision response.
    //
    // 0 means the snake won't physically bounce or be pushed
    // around by other physics bodies.
    //
    // We only want to DETECT collisions, not have SpriteKit's
    // physics engine physically move the snake around.
    part.physicsBody?.collisionBitMask = 0


    // Apply the special red shader effect to the snake head.
    //
    // A shader is a small graphics program that runs on the GPU
    // and controls how pixels are rendered.
    setHeadShader(part: part)


    // Add the new snake part to our game layer.
    //
    // gameLayer is the container node that holds the game's
    // objects.
    gameLayer.addChild(part)


    // Insert the new part at index 0.
    //
    // index 0 is the first position in the array.
    //
    // The first element of snake is treated as the head.
    //
    // Example:
    //
    // Before:
    // [Body, Body]
    //
    // After:
    // [NewHead, Body, Body]
    snake.insert(part, at: 0)
}


// MARK: - Snake Body Shader

// Applies a green gradient shader to a snake body part.
//
// SKShader allows us to customize how the shape is rendered.
func setBodyShader(part: SKShapeNode) {

    // Create a shader using GLSL shader source code.
    //
    // The code between """ and """ is a multiline String.
    //
    // SpriteKit sends this shader code to the graphics system
    // to determine the color of each pixel.
    let shader = SKShader(source: """
    void main() {

        // v_tex_coord contains the texture coordinate
        // of the current pixel.
        //
        // UV coordinates normally range from 0.0 to 1.0.
        vec2 uv = v_tex_coord;


        // Calculate the distance from the current pixel
        // to the center of the shape.
        //
        // vec2(0.5, 0.5) represents the center of the
        // texture coordinates.
        float dist = distance(
            uv,
            vec2(0.5, 0.5)
        );


        // Set the final pixel color.
        //
        // vec4 represents:
        //
        // Red
        // Green
        // Blue
        // Alpha
        //
        // Here:
        // Red   = 0.0
        // Green = 1.0 - dist
        // Blue  = 0.0
        // Alpha = 1.0
        //
        // The result creates a green gradient.
        gl_FragColor = vec4(
            0.0,
            1.0 - dist,
            0.0,
            1.0
        );
    }
    """)


    // Attach the shader to the shape.
    //
    // fillShader controls how the inside of the SKShapeNode
    // is rendered.
    part.fillShader = shader
}


// MARK: - Snake Head Shader

// Applies a red gradient shader to the snake head.
func setHeadShader(part: SKShapeNode) {

    // Create the shader program.
    let shader = SKShader(source: """
    void main() {

        // Get the current pixel's texture coordinates.
        vec2 uv = v_tex_coord;


        // Calculate how far the pixel is from the center.
        float dist = distance(
            uv,
            vec2(0.5, 0.5)
        );


        // Create the final red color.
        //
        // As dist increases, 1.0 - dist becomes smaller,
        // producing a gradient effect.
        //
        // Red   = 1.0 - dist
        // Green = 0.0
        // Blue  = 0.0
        // Alpha = 1.0
        gl_FragColor = vec4(
            1.0 - dist,
            0.0,
            0.0,
            1.0
        );
    }
    """)


    // Attach the shader to the snake head.
    part.fillShader = shader
}


// MARK: - Grid Positioning

// Moves a point onto our Snake game's grid.
//
// This is important because Snake is a grid-based game.
//
// Instead of allowing the snake to sit at arbitrary positions
// such as:
//
// x = 37.83
// y = 94.27
//
// we want positions aligned to our cellSize.
func snapToGrid(_ point: CGPoint) -> CGPoint {

    // Calculate the X position of the grid cell.
    //
    // point.x / cellSize tells us which grid cell the point
    // belongs to.
    //
    // floor() removes the decimal part and rounds DOWN.
    //
    // Multiplying by cellSize converts the grid number
    // back into a pixel position.
    //
    // Finally, cellSize / 2 moves the point to the CENTER
    // of the grid cell.
    let x =
        floor(point.x / cellSize) * cellSize
        + cellSize / 2


    // Do exactly the same calculation for the Y coordinate.
    let y =
        floor(point.y / cellSize) * cellSize
        + cellSize / 2


    // Create and return a new CGPoint using the calculated
    // grid-aligned X and Y positions.
    return CGPoint(
        x: x,
        y: y
    )
}

}
