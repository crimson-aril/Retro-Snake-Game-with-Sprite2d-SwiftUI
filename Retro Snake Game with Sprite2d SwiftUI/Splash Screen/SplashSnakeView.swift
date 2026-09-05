//
//  SplashSnakeView.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// SwiftUI provides the tools needed to build this splash screen.
import SwiftUI

// SplashSnakeView is the SwiftUI view displayed when the app starts.
//
// "View" is a SwiftUI protocol. By conforming to it, this struct
// can describe something that appears on the screen.
struct SplashSnakeView: View {


// @State stores data that can change while this view is running.
//
// When this value changes, SwiftUI automatically updates the
// parts of the interface that depend on it.
//
// We use this Boolean to control the animation.
//
// false = animation has not started
// true  = animation is active
@State private var animate = false


// body describes everything that should appear on the screen.
//
// "some View" means this property returns a type that conforms
// to SwiftUI's View protocol.
var body: some View {

    // ZStack places views on top of each other.
    //
    // We use it here because we want the gradient to act as
    // the background while the other UI elements appear above it.
    ZStack {

        // Create a diagonal gradient for the background.
        //
        // The gradient transitions through three colors:
        // cyan → blue → black
        LinearGradient(
            colors: [.cyan, .blue, .black],

            // The gradient starts in the top-left corner.
            startPoint: .topLeading,

            // The gradient finishes in the bottom-right corner.
            endPoint: .bottomTrailing
        )

        // Make the background extend across the entire screen,
        // including areas normally reserved by the system UI.
        .ignoresSafeArea()


        // VStack arranges its child views vertically.
        //
        // Everything inside this VStack appears from top to bottom.
        VStack {

            // Spacer takes up available empty space.
            //
            // This pushes the content toward the middle of the screen.
            Spacer()


            // Display the splash image from the app's asset catalog.
            //
            // Image(.splash) uses the image named "splash"
            // from the project's asset catalog.
            Image(.splash)

                // Allow the image to resize when the available
                // screen size changes.
                .resizable()

                // Keep the image's original aspect ratio while
                // fitting it inside the available space.
                .scaledToFit()

                // Add a soft shadow underneath the image.
                //
                // opacity(0.3) makes the shadow partially transparent.
                //
                // radius controls how blurry the shadow is.
                //
                // x and y control the shadow's position.
                .shadow(
                    color: .black.opacity(0.3),
                    radius: 10,
                    x: 0,
                    y: 5
                )

                // Slightly enlarge or shrink the image depending
                // on the value of animate.
                //
                // When animate is true:
                //     scale = 1.05
                //
                // When animate is false:
                //     scale = 0.95
                //
                // This creates a subtle breathing/pulsing effect.
                .scaleEffect(animate ? 1.05 : 0.95)

                // Animate changes to the animate state.
                //
                // easeInOut makes the animation start and stop smoothly.
                //
                // duration: 1 means one animation transition takes
                // one second.
                //
                // repeatForever() makes the animation continue forever.
                //
                // value: animate tells SwiftUI that this animation
                // should happen when "animate" changes.
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(),
                    value: animate
                )


            // Display the game's title.
            Text("Snake Adventure")

                // Use SwiftUI's large title font.
                .font(.largeTitle)

                // Make the text bold.
                .bold()

                // Give the text a gradient instead of a single color.
                //
                // The gradient goes from green to yellow.
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .yellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

                // Add a shadow around the title to make it stand out.
                .shadow(radius: 5)

                // Add 25 points of space below the title.
                .padding(.bottom, 25)


            // Display a short message underneath the title.
            Text("Get ready to slither and score!")

                // Use a headline-sized font.
                .font(.headline)

                // Make the text white but slightly transparent.
                //
                // 1.0 = fully visible
                // 0.0 = completely transparent
                .foregroundStyle(.white.opacity(0.8))


            // Another Spacer pushes the progress indicator
            // toward the bottom of the screen.
            Spacer()


            // ProgressView displays a loading/progress indicator.
            //
            // Since no progress value is provided, SwiftUI displays
            // an indeterminate loading indicator.
            ProgressView()

                // Make the progress indicator 1.5 times larger.
                .scaleEffect(1.5)

                // Change the indicator's tint color to green.
                .tint(.green)

                // Add 50 points of space below the indicator.
                .padding(.bottom, 50)
        }

        // Add padding around the entire VStack.
        //
        // This prevents the content from sitting directly
        // against the edges of the screen.
        .padding()
    }


    // onAppear runs when this view appears on screen.
    //
    // This is where we start our image animation.
    .onAppear {

        // Change animate from false to true.
        //
        // Because animate is @State, SwiftUI notices this change
        // and updates the view.
        //
        // The .animation(...) modifier on the image then animates
        // the change from scale 0.95 to scale 1.05.
        animate = true
    }
}


}

// MARK: - SwiftUI Preview

// #Preview lets Xcode show this view in the SwiftUI Preview canvas.
//
// This is useful while developing because you can see the splash
// screen without manually launching the complete application.
#Preview {


// Create an instance of SplashSnakeView for the preview.
SplashSnakeView()


}
