//
//  Setup Physics.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SpriteKit provides the physics system used by the game.
import SpriteKit


// MARK: - Physics Setup

// Add physics-related functionality to GameScene.
//
// Keeping this in a separate extension makes the project easier
// to organize.
extension GameScene {

    // Configures the physics world and the game's boundary.
    func setupPhysics() {

        // Remove gravity from the physics world.
        //
        // A Snake game does not need objects to fall downward,
        // so we set gravity to zero.
        self.physicsWorld.gravity = .zero

        // Tell SpriteKit that this GameScene will receive
        // physics contact notifications.
        //
        // When two physics bodies make contact, SpriteKit can
        // call the didBegin(_:) function in GameScene.
        self.physicsWorld.contactDelegate = self

        // Create an invisible physics boundary around the
        // edges of the game scene.
        //
        // edgeLoopFrom creates a physics body following the
        // edges of the supplied rectangle.
        //
        // Here, self.frame represents the boundaries of GameScene.
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Give the scene's boundary the "wall" physics category.
        //
        // This allows the collision system to recognize the
        // scene boundary as a wall.
        self.physicsBody?.categoryBitMask = PhysicsCategory.wall

        // Tell SpriteKit to notify us when the wall comes into
        // contact with either the snake's head or body.
        //
        // The | operator combines the two physics categories.
        self.physicsBody?.contactTestBitMask = PhysicsCategory.head | PhysicsCategory.body

        // Define which objects are allowed to physically collide
        // with the wall.
        //
        // Both the snake's head and body can collide with the wall.
        self.physicsBody?.collisionBitMask = PhysicsCategory.head | PhysicsCategory.body
    }
}
