
//
//  createSwipeGestures.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Foundation provides basic Swift and system functionality.
import Foundation

// SpriteKit provides SKView and other game-related classes.
import SpriteKit

// UIKit is only available on Apple platforms that use UIKit,
// such as iOS.
//
// The #if condition means this import will only be compiled
// when building the project for iOS.
#if os(iOS)
import UIKit
#endif


// MARK: - Swipe Gestures

// An extension allows us to add more functionality to GameScene
// without putting everything inside the main GameScene class.
//
// This file is responsible for detecting swipe gestures.
extension GameScene {

    // Creates the swipe gestures used to control the snake.
    //
    // The SKView is passed into this function because the gesture
    // recognizers need to be attached to the view that displays
    // the SpriteKit game.
    func createSwipeGestures(view: SKView) {

        // This code is only compiled when the game is built for iOS.
        #if os(iOS)

        // Create an array containing all four directions
        // that the player can swipe.
        //
        // UISwipeGestureRecognizer.Direction is an enum provided
        // by UIKit.
        let directions: [UISwipeGestureRecognizer.Direction] = [
            .up,
            .down,
            .left,
            .right
        ]

        // Loop through every direction in the array.
        //
        // Instead of writing four separate gesture recognizers,
        // we create them automatically inside this loop.
        for dir in directions {

            // Create a swipe gesture recognizer.
            //
            // target: self
            // ----------------
            // "self" means the current GameScene object.
            //
            // When the swipe happens, the gesture recognizer
            // will send the event to this GameScene.
            //
            // action: #selector(handleswipe(_:))
            // ---------------------------------
            // Tells UIKit which function should be called
            // when the swipe is detected.
            let swipe = UISwipeGestureRecognizer(
                target: self,
                action: #selector(handleswipe(_:))
            )

            // Tell this gesture recognizer which direction
            // it should detect.
            //
            // The value of "dir" comes from the current item
            // in the directions array.
            swipe.direction = dir

            // Attach the gesture recognizer to the SpriteKit view.
            //
            // From this point on, the view can detect this
            // type of swipe.
            view.addGestureRecognizer(swipe)
        }

        #elseif os(macOS)

        // On macOS, this project uses keyboard controls instead
        // of touchscreen swipe gestures.
        //
        // The arrow keys are handled by GameScene's
        // keyDown(_:) function.
        //
        // This section does not create any gesture recognizers.

        // Optional: If you want to support Mac, you could handle keyboard arrow keys in GameScene's keyDown(_:) instead.

        #endif
    }


    // This function handles a swipe after iOS detects it.
    //
    // @objc is required because UIKit's gesture recognizer
    // calls this function through Objective-C's selector system.
    //
    // private means this function is only used inside GameScene.
    //
    // The gesture parameter tells us which direction the player
    // swiped.
    #if os(iOS)

    @objc private func handleswipe(_ gesture: UISwipeGestureRecognizer) {

        // Check which direction the user swiped.
        //
        // gesture.direction contains the detected direction.
        switch gesture.direction {

        case .up:

            // Move the snake upward.
            //
            // We only allow this if the snake is currently moving
            // horizontally (dy == 0).
            //
            // This prevents the snake from immediately reversing
            // into itself.
            if direction.dy == 0 {
                direction = .init(dx: 0, dy: 1)
            }

        case .down:

            // Move the snake downward.
            //
            // Again, dy must currently be 0 so the snake cannot
            // instantly reverse its vertical direction.
            if direction.dy == 0 {
                direction = .init(dx: 0, dy: -1)
            }

        case .left:

            // Move the snake to the left.
            //
            // We only allow this when the snake is currently
            // moving vertically (dx == 0).
            if direction.dx == 0 {
                direction = .init(dx: -1, dy: 0)
            }

        case .right:

            // Move the snake to the right.
            //
            // We only allow this when the snake is currently
            // moving vertically (dx == 0).
            if direction.dx == 0 {
                direction = .init(dx: 1, dy: 0)
            }

        default:

            // Do nothing for any other direction.
            break
        }
    }

    #endif
}

