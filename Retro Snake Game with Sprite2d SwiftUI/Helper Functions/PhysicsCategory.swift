
//
//  PhysicsCategory.swift
//  Retro Snake Game with Sprite2d SwiftUI
//
//  Created by noor on 4/9/26.
//

// MARK: - Physics Categories

// This struct contains the different physics categories used
// by the game.
//
// SpriteKit uses category bit masks to identify different types
// of physics objects, such as the snake's head, food, walls,
// and the snake's body.
struct PhysicsCategory {

    // The snake's head belongs to category 0.
    //
    // 0x1 is a hexadecimal value representing 1.
    // Shifting it left by 0 keeps it at the first bit:
    //
    // 0001
    //
    // This category is used to identify the snake's head.
    static let head: UInt32 = 0x1 << 0

    // The wall belongs to category 1.
    //
    // 0001 shifted left by 1 becomes:
    //
    // 0010
    //
    // This gives the wall its own unique bit.
    static let wall: UInt32 = 0x1 << 1

    // The food belongs to category 2.
    //
    // 0001 shifted left by 2 becomes:
    //
    // 0100
    //
    // This allows the game to identify food separately
    // from the head and walls.
    static let food: UInt32 = 0x1 << 2

    // The snake's body belongs to category 3.
    //
    // 0001 shifted left by 3 becomes:
    //
    // 1000
    //
    // This gives the body its own unique physics category.
    static let body: UInt32 = 0x1 << 3
}
