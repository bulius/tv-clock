//
//  ConfettiView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/8/26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    let colors: [Color] = [
        Color(red: 1.0, green: 0.231, blue: 0.188),    // Vibrant Red
        Color(red: 1.0, green: 0.584, blue: 0.0),      // Vibrant Orange
        Color(red: 1.0, green: 0.8, blue: 0.0),        // Vibrant Yellow
        Color(red: 0.298, green: 0.851, blue: 0.392),  // Vibrant Green
        Color(red: 0.0, green: 0.478, blue: 1.0),      // Vibrant Blue
        .purple,
        .pink,
        .cyan,
        .mint,
        .indigo
    ]
    
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
        
        // Reduced to 200 pieces for optimal tvOS performance
        confettiPieces = (0..<200).map { index in
            // Random angle for explosion (full 360 degrees)
            let angle = Double.random(in: 0...(2 * .pi))
            
            // Random explosion force - some pieces go far, some stay closer
            let explosionForce = CGFloat.random(in: 150...500)
            
            // Calculate velocity based on angle and force
            let velocityX = cos(angle) * explosionForce
            let velocityY = sin(angle) * explosionForce
            
            // Add some upward bias so confetti also goes up
            let upwardBias = CGFloat.random(in: -150...30)
            
            return ConfettiPiece(
                id: index,
                color: colors.randomElement() ?? .red,
                position: CGPoint(x: centerX, y: centerY),
                size: CGFloat.random(in: 10...20),
                velocity: CGPoint(x: velocityX, y: velocityY + upwardBias),
                rotationSpeed: CGFloat.random(in: -12...12),
                horizontalDrift: CGFloat.random(in: -1.5...1.5),
                delay: Double.random(in: 0...0.08)
            )
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let color: Color
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
        RoundedRectangle(cornerRadius: piece.size * 0.2)
            .fill(piece.color)
            .frame(width: piece.size, height: piece.size * 1.5)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                // Initial explosion with quick outward motion
                withAnimation(
                    .easeOut(duration: 0.4)
                    .delay(piece.delay)
                ) {
                    position.x += piece.velocity.x * 0.6
                    position.y += piece.velocity.y * 0.6
                    scale = 1.3
                }
                
                // Continue with slower gravity-influenced fall
                withAnimation(
                    .timingCurve(0.1, 0.9, 0.3, 1.0, duration: 6.0)
                    .delay(0.4 + piece.delay)
                ) {
                    // Apply reduced gravity (pieces fall slower)
                    position.y = screenSize.height + 100
                    position.x += piece.velocity.x * 0.2 + piece.horizontalDrift * 100
                    scale = 0.9
                }
                
                // Continuous rotation
                withAnimation(
                    .linear(duration: 4.0)
                    .repeatForever(autoreverses: false)
                    .delay(piece.delay)
                ) {
                    rotation = piece.rotationSpeed * 360
                }
                
                // Fade out near the end
                withAnimation(
                    .easeIn(duration: 0.6)
                    .delay(5.8 + piece.delay)
                ) {
                    opacity = 0
                }
            }
    }
}

#Preview {
    ZStack {
        Color.black
        ConfettiView()
    }
}
