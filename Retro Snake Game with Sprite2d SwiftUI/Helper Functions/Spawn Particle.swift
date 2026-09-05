
//
//  Spawn Particle.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Foundation provides basic Swift functionality.
import Foundation

// SpriteKit provides SKEmitterNode and SKAction,
// which we use for the particle effect and its animation.
import SpriteKit


// MARK: - Particle Effect

// Add particle-related functionality to GameScene.
//
// An extension keeps this code separate from the main
// GameScene implementation.
extension GameScene {

    // Creates a particle effect at the specified position.
    //
    // The position parameter tells the function where the
    // particle effect should appear in the game.
    func spawnParticle(at position: CGPoint) {

        // Try to load the particle effect from the .sks file.
        //
        // SKEmitterNode(fileNamed:) loads an emitter configuration
        // that was created and saved in SpriteKit's particle editor.
        //
        // The guard statement makes sure the file was loaded
        // successfully before continuing.
        //
        // If "MyParticle.sks" cannot be found or loaded,
        // the function simply stops.
        guard let emitter = SKEmitterNode(fileNamed: "MyParticle.sks") else {
            return
        }

        // Put the particle emitter at the position provided
        // to the function.
        emitter.position = position

        // Place the particles in front of most other game objects.
        //
        // A higher zPosition is drawn in front of nodes
        // with a lower zPosition.
        emitter.zPosition = 10

        // Add the particle emitter to the game's main layer
        // so SpriteKit can display the effect.
        gameLayer.addChild(emitter)


        // MARK: - Particle Cleanup Animation

        // Wait for one second before starting the fade-out.
        let wait = SKAction.wait(forDuration: 1)

        // Gradually make the particle emitter transparent
        // over half a second.
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)

        // Remove the emitter from the scene after the animation.
        //
        // This is important because the emitter is no longer
        // needed after its effect has finished.
        let remove = SKAction.removeFromParent()

        // Run all three actions in order:
        //
        // 1. Wait for 1 second
        // 2. Fade out over 0.5 seconds
        // 3. Remove the emitter from the scene
        //
        // SKAction.sequence() guarantees that they happen
        // one after another.
        emitter.run(.sequence([wait, fadeOut, remove]))
    }
}
