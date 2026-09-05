//
//  Retro_Snake_Game_with_Sprite2d_SwiftUIApp.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// Import SwiftUI so we can use SwiftUI's App and Scene types.
import SwiftUI

// @main tells Swift that this is the entry point of the application.
//
// Every Swift application needs a starting point.
// When the app launches, Swift looks for the type marked with @main
// and starts the application from there.
@main
struct Retro_Snake_Game_with_Sprite2d_SwiftUIApp: App {


// The body describes the application's scene structure.
//
// "some Scene" means this property returns a type that conforms
// to SwiftUI's Scene protocol.
//
// A Scene represents a part of the application's user interface
// and window/lifecycle structure.
var body: some Scene {

    // WindowGroup creates the main window for the application.
    //
    // On iOS, this represents the main app interface.
    // On macOS, it can create the application's main window.
    //
    // SwiftUI manages the window for us, so we don't need to
    // manually create and manage an NSWindow or UIWindow.
    WindowGroup {

        // ContentView is the first SwiftUI view displayed
        // inside our application's window.
        //
        // ContentView then decides whether to show:
        //
        
        ContentView()
    }
}
}
