
//
//  setupBackgroundMusic.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Foundation provides basic system functionality,
// including access to resources in the app bundle.
import Foundation

// SpriteKit provides SKAudioNode and SKAction,
// which we use to play and control the music.
import SpriteKit


// MARK: - Background Music

// Add background-music functionality to GameScene.
//
// Keeping the music setup in its own extension/file helps
// separate audio-related code from the rest of the game logic.
extension GameScene {

    // Finds the background music file and starts playing it.
    func setupBackgroundMusic() {

        // Try to find the music file inside the app's bundle.
        //
        // Bundle.main represents the resources that were packaged
        // with the application.
        //
        // musicName comes from GameScene and contains the name
        // of the music file without its ".mp3" extension.
        if let musicURL = Bundle.main.url(
            forResource: musicName,
            withExtension: "mp3"
        ) {

            // Create an SKAudioNode using the URL of the music file.
            //
            // An SKAudioNode is a SpriteKit node that can play audio.
            let musicNode = SKAudioNode(url: musicURL)

            // Automatically repeat the music when it reaches the end.
            //
            // This makes the background music continue playing
            // instead of stopping after one play.
            musicNode.autoplayLooped = true

            // Add the audio node to the GameScene.
            //
            // Like other SpriteKit nodes, an SKAudioNode needs
            // to be part of the scene hierarchy to play.
            addChild(musicNode)

            // Store the audio node in the backgroundMusic property.
            //
            // This lets other parts of GameScene access the music
            // later, for example when changing its volume.
            backgroundMusic = musicNode

            // Set the initial music volume.
            //
            // "volume" is a property defined in GameScene.
            //
            // duration: 0 means the volume changes immediately
            // instead of gradually fading to the new volume.
            backgroundMusic?.run(
                SKAction.changeVolume(
                    to: volume,
                    duration: 0
                )
            )
        }
    }
}

