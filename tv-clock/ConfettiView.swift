//
//  ConfettiView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/8/26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    // AM Timer emojis (before noon) - assorted smiley faces
    private let amEmojis = ["😀", "😃", "😄", "😁", "😆", "😊", "☺️", "😍", "🥰", "😎", "🤩", "😇", "🙂", "😉"]
    
    // PM Timer emojis (after noon) - Zzz and sleeping faces
    private let pmEmojis = ["😴", "💤", "😴", "💤", "😴", "💤", "😪"]
    
    // Determine which emoji set to use based on current time
    private var currentEmojis: [String] {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? amEmojis : pmEmojis
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ExplosiveConfettiPieceView(piece: piece, screenSize: geometry.size)
                }
            }
            .onAppear {
                generateExplosiveConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func generateExplosiveConfetti(in size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let emojis = currentEmojis
        
        // Create 250 pieces for a spectacular fireworks display
        confettiPieces = (0..<250).map { index in
            // Random angle for explosion (full 360 degrees)
            let angle = Double.random(in: 0...(2 * .pi))
            
            // Variable explosion force for layered effect
            let explosionForce = CGFloat.random(in: 300...900)
            
            // Calculate velocity based on angle and force
            let velocityX = cos(angle) * explosionForce
            let velocityY = sin(angle) * explosionForce
            
            return ConfettiPiece(
                id: index,
                emoji: emojis.randomElement() ?? "😀",
                position: CGPoint(x: centerX, y: centerY),
                size: CGFloat.random(in: 30...60),
                velocity: CGPoint(x: velocityX, y: velocityY),
                rotationSpeed: CGFloat.random(in: -12...12),
                horizontalDrift: CGFloat.random(in: -1.5...1.5),
                delay: Double.random(in: 0...0.08) // Quick staggered burst
            )
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let emoji: String
    let position: CGPoint
    let size: CGFloat
    let velocity: CGPoint // Changed to CGPoint for x and y velocity
    let rotationSpeed: CGFloat
    let horizontalDrift: CGFloat
    let delay: Double
}

struct ExplosiveConfettiPieceView: View {
    let piece: ConfettiPiece
    let screenSize: CGSize
    
    @State private var position: CGPoint
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1.0
    
    init(piece: ConfettiPiece, screenSize: CGSize) {
        self.piece = piece
        self.screenSize = screenSize
        _position = State(initialValue: piece.position)
    }
    
    var body: some View {
        Text(piece.emoji)
            .font(.system(size: piece.size))
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                animateFireworks()
            }
    }
    
    private func animateFireworks() {
        // PHASE 1: Explosive burst (0.0 - 0.5s)
        // Rapid outward explosion from center
        withAnimation(
            .easeOut(duration: 0.5)
            .delay(piece.delay)
        ) {
            // Full velocity explosion
            position.x += piece.velocity.x * 0.5
            position.y += piece.velocity.y * 0.5
            scale = 1.4 // Pop effect
        }
        
        // PHASE 2: Continue outward expansion (0.5 - 4.0s)
        // Pieces continue moving outward in their direction but slow down
        withAnimation(
            .easeOut(duration: 3.5)
            .delay(0.5 + piece.delay)
        ) {
            // Continue moving outward in the same direction
            position.x += piece.velocity.x * 1.2
            position.y += piece.velocity.y * 1.2
            scale = 1.0
        }
        
        // ROTATION: Continuous spin throughout
        withAnimation(
            .linear(duration: 4.0)
            .repeatForever(autoreverses: false)
            .delay(piece.delay)
        ) {
            rotation = piece.rotationSpeed * 360
        }
        
        // FADE OUT: Gradually disappear as they move outward
        withAnimation(
            .easeIn(duration: 2.5)
            .delay(1.5 + piece.delay)
        ) {
            opacity = 0
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ConfettiView()
    }
}
