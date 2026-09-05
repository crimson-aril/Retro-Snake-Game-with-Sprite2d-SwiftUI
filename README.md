# 🐍 Retro Snake Game with Sprite2D & SwiftUI

A simple retro-style Snake game built with **Swift**, **SpriteKit**, and **SwiftUI**.

The project combines SpriteKit's 2D game engine with SwiftUI to create a small cross-platform game with grid-based movement, fruit collection, sound controls, particle effects, and swipe/keyboard controls.

## ✨ Features

* 🐍 Grid-based Snake movement
* 🍎 Random fruit spawning
* 🍌 Multiple fruit types
* 🎯 Collision detection
* 💥 Particle effects when eating food
* 🎵 Background music
* 🔊 Sound toggle
* ➕➖ Volume controls
* 📊 Score counter
* 💀 Game Over screen
* 🔄 Tap/click to restart
* 👆 Swipe controls on iOS
* ⌨️ Keyboard controls on macOS
* ✨ Animated food effects
* 🎨 Custom SpriteKit shaders for the snake
* 🌐 SwiftUI interface
* 📱 iOS support
* 🖥️ macOS support

## 🛠️ Technologies

* **Swift**
* **SwiftUI**
* **SpriteKit**
* **Foundation**
* **UIKit** — used for iOS swipe gestures

## 📂 Project Structure

The project separates different parts of the game into individual Swift files to keep the code organized and easier to learn.

```text
Retro Snake Game with Sprite2d SwiftUI
│
├── Retro_Snake_Game_with_Sprite2d_SwiftUIApp.swift
├── ContentView.swift
├── SplashSnakeView.swift
│
├── GameScene.swift
├── Setup Game.swift
├── Setup Grid.swift
├── Setup Physics.swift
│
├── Move Snake.swift
├── Add Snake Part.swift
├── Spawn Food.swift
├── Spawn Particle.swift
│
├── Create Score.swift
├── Buttons.swift
├── createSwipeGestures.swift
├── setupBackgroundMusic.swift
├── Game Over.swift
│
├── PhysicsCategory.swift
│
└── Resources
    ├── Fruit images
    ├── eat.mp3
    ├── Background music
    ├── MyParticle.sks
    └── Splash image
```

## 🎮 Controls

### iOS

Swipe in one of the four directions:

* ⬆️ Swipe Up
* ⬇️ Swipe Down
* ⬅️ Swipe Left
* ➡️ Swipe Right

### macOS

Use the keyboard arrow keys:

* ↑ Up
* ↓ Down
* ← Left
* → Right

The game also includes on-screen sound and volume controls.

## 🐍 How the Snake Works

The snake is stored as an array of `SKShapeNode` objects:

```swift
snake[0] // Head
snake[1] // Body
snake[2] // Body
...
```

When the snake moves, a new head is created at the next grid position and the last body segment is removed.

```text
Before:

🟥 🟩 🟩 🟩

Move →

After:

🟥 🟩 🟩 🟩
```

This creates the appearance of continuous movement while keeping the snake aligned to the grid.

## 🍎 Food System

Food is spawned at random grid positions inside the playable area.

The game currently supports:

* Apple
* Banana
* Pineapple
* Strawberry
* Watermelon

The fruit is selected randomly whenever new food is spawned.

The food also has a small pulsing animation to make it visually stand out.

## 💥 Particle Effects

When the snake eats food, a SpriteKit particle emitter is created using:

```text
MyParticle.sks
```

The particle effect appears at the snake's head, waits briefly, fades out, and is then removed from the scene.

## 🎵 Audio

The game includes background music and eating sound effects.

The player can:

* Enable or disable sound
* Increase the music volume
* Decrease the music volume

The background music automatically loops while the game is running.

## 🧱 Physics

SpriteKit physics categories are used to identify different game objects.

```swift
PhysicsCategory.head
PhysicsCategory.wall
PhysicsCategory.food
PhysicsCategory.body
```

These categories allow the game to detect collisions such as:

```text
Snake Head → Food
Snake Head → Body
Snake Head → Wall
```

## 🎨 Snake Shaders

The snake uses custom SpriteKit shaders to create a simple gradient effect.

The head uses a red shader while body segments use a green shader.

This gives the snake a more distinctive retro appearance than using a flat color alone.

## 🖼️ SwiftUI + SpriteKit

SwiftUI provides the application's interface while SpriteKit handles the actual game.

The game scene is displayed using:

```swift
SpriteView(scene: scene)
```

This allows the SpriteKit `GameScene` to be embedded directly inside a SwiftUI view.

The project also includes a SwiftUI splash screen that appears when the application launches.

## 🔄 Game Restart

When the game ends, `isGameOver` is set to `true` and a Game Over message is displayed.

Tapping or clicking the game calls the restart logic, which runs:

```swift
setupGame()
```

The game setup function resets the previous game state and creates a new game.

## 📚 Learning Purpose

This project is also intended as a learning project for understanding:

* Swift fundamentals
* SwiftUI
* SpriteKit
* `SKScene`
* `SKNode`
* `SKShapeNode`
* `SKSpriteNode`
* SpriteKit physics
* Physics bit masks
* Collision detection
* `SKAction`
* SpriteKit shaders
* Particle emitters
* Audio nodes
* Gesture recognizers
* Cross-platform Swift code
* SwiftUI and SpriteKit integration
* Swift extensions

The code is organized into small files with comments explaining the main concepts, making the project easier to study and modify.

## 🚀 Getting Started

### Requirements

* Xcode
* Swift
* iOS or macOS development environment

### Installation

1. Clone or download the repository.
2. Open the project in Xcode.
3. Make sure all required image, audio, and SpriteKit resources are included in the project target.
4. Select an iOS device/simulator or macOS as the destination.
5. Build and run the project.

## 📜 License

This project is provided for learning and experimentation.

Assets used in this project has all rights reserved by their owners/creators, I do not own them, just used them for educational purposes

---

Made with ❤️ and Swift.
