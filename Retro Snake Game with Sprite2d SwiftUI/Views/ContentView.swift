//
//  ContentView.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SwiftUI provides the tools for creating the application's user interface.
import SwiftUI

// SpriteKit provides the 2D game engine that we use for our Snake game.
import SpriteKit

// ContentView is the main SwiftUI view of our application.
//
// A SwiftUI View describes what should appear on the screen.
// SwiftUI automatically updates the UI when the view's state changes.
struct ContentView: View {


// Create the SpriteKit scene that will contain our game.
//
// SKScene represents a 2D game world.
//
// This property creates a new GameScene and tells SpriteKit
// how the scene should fit inside the available screen space.
var scene: SKScene {

    // Create an instance of our custom GameScene class.
    let scene = GameScene()

    // .resizeFill tells SpriteKit to resize the scene so that
    // it fills the SpriteView.
    //
    // This is useful because the screen size can be different
    // between devices and platforms.
    scene.scaleMode = .resizeFill

    // Return the configured scene.
    return scene
}


// @State stores a value that belongs to this SwiftUI view.
//
// When the value changes, SwiftUI automatically redraws
// the parts of the UI that depend on it.
//
// We start by showing the splash screen.
@State private var showSplash = true


// @AppStorage saves a value using UserDefaults.
//
// Unlike @State, this value can survive after the app is closed
// and opened again.
//
// "splashCount" is the key used to store this value.
//
// private means only ContentView can directly access this property.
//
// We use this counter to remember how many times the splash
// screen has been shown.
@AppStorage("splashCount") private var splashCount = 0


// body describes the UI that SwiftUI should display.
//
// some View means:
// "This returns some type that conforms to the View protocol."
var body: some View {

    // VStack arranges its child views vertically.
    VStack {

        // Show the splash screen only when BOTH conditions are true:
        //
        // 1. showSplash is true
        // 2. splashCount is less than 3
        //
        // && means "AND".
        if showSplash && splashCount < 3 {

            // Display our custom splash screen.
            SplashSnakeView()

        } else {

            // ZStack places views on top of one another.
            //
            // Here we want the gradient behind the SpriteKit game.
            ZStack {

                // Create a gradient background.
                //
                // LinearGradient smoothly changes from one color
                // to another along a straight line.
                //
                // colors:
                // The colors used by the gradient.
                //
                // startPoint:
                // Where the gradient begins.
                //
                // endPoint:
                // Where the gradient finishes.
                LinearGradient(
                    colors: [.cyan, .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // opacity() makes the gradient slightly transparent.
                //
                // 1.0 = completely visible
                // 0.0 = completely transparent
                .opacity(0.9)


                // SpriteView embeds a SpriteKit SKScene
                // inside a SwiftUI view.
                //
                // This is the bridge between SwiftUI and SpriteKit.
                //
                // scene:
                // The GameScene containing our Snake game.
                //
                // .allowsTransparency:
                // Allows the SpriteKit scene to have transparent areas.
                //
                // This is important because we want the SwiftUI
                // gradient to remain visible behind the game.
                SpriteView(
                    scene: scene,
                    options: [.allowsTransparency]
                )
            }

            // Allow this entire game view to extend underneath
            // the device's safe areas.
            //
            // For example, the game can extend to the edges of
            // the screen instead of stopping around the
            // status bar or home indicator.
            .ignoresSafeArea()
        }
    }

    // onAppear runs code when ContentView appears on screen.
    //
    // This is useful for performing setup or starting an action
    // when a view becomes visible.
    .onAppear {

        // Increase the number of times the splash screen
        // has been shown.
        //
        // Because splashCount uses @AppStorage, the updated
        // value is saved using UserDefaults.
        splashCount += 1


        // Wait for a short amount of time before hiding
        // the splash screen.
        //
        // DispatchQueue.main is the main thread.
        //
        // UI changes should generally happen on the main thread.
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {

            // withAnimation tells SwiftUI to animate
            // changes that happen inside this block.
            withAnimation {

                // Hide the splash screen.
                //
                // Changing @State causes SwiftUI to recalculate
                // the body and update the UI.
                showSplash = false
            }
        }
    }
}

}

// MARK: - SwiftUI Preview

// #Preview allows Xcode's SwiftUI Preview system to display
// ContentView while developing.
//
// It lets you see the interface without manually running the
// entire application every time.
#Preview {


// Create ContentView for the preview.
ContentView()


}
