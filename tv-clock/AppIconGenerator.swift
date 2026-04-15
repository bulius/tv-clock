//
//  AppIconGenerator.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/8/26.
//
//  DESIGN REFERENCE for AppIcon.icon
//
//  This file contains the visual design for the app icon.
//  Use these specifications when creating your AppIcon.icon file.
//
//  📋 To use with AppIcon.icon:
//  1. Create AppIcon.icon in Xcode (File → New → Resource → App Icon)
//  2. Add SF Symbol: sun.min.fill
//  3. Apply the gradient colors below
//  4. Set symbol color to white
//
//  🎨 Color Palette:
//  - Top: #FFD94D (rgb: 1.0, 0.85, 0.3) - Bright sunrise yellow
//  - Mid: #FF9933 (rgb: 1.0, 0.6, 0.2) - Warm orange
//  - Bot: #F26440 (rgb: 0.95, 0.4, 0.25) - Deep sunrise orange
//

import SwiftUI

/// Design reference view for the app icon
/// Use this to visualize or export a 1024x1024 image for AppIcon.icon
struct AppIconView: View {
    var body: some View {
        ZStack {
            // Sunrise gradient background - warm morning colors
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.85, blue: 0.3),   // Bright sunrise yellow
                    Color(red: 1.0, green: 0.6, blue: 0.2),    // Warm orange
                    Color(red: 0.95, green: 0.4, blue: 0.25)   // Deep sunrise orange
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Glass texture overlay for depth
            RadialGradient(
                colors: [
                    Color.white.opacity(0.25),
                    Color.white.opacity(0.0)
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
            
            // Sun icon with glass material effect
            ZStack {
                // Outer glow layer - creates the radiant effect
                Image(systemName: "sun.min.fill")
                    .font(.system(size: 280, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 8)
                    .opacity(0.7)
                
                // Main sun with glass effect
                Image(systemName: "sun.min.fill")
                    .font(.system(size: 280, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .white.opacity(0.9), radius: 20, x: -4, y: -4)
                    .shadow(color: Color(red: 0.8, green: 0.4, blue: 0.2).opacity(0.4), radius: 12, x: 6, y: 6)
                
                // Top highlight for glass shine effect
                Image(systemName: "sun.min.fill")
                    .font(.system(size: 280, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .offset(x: -3, y: -3)
                    .blendMode(.overlay)
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

// MARK: - Previews for AppIcon.icon Export

#Preview("App Icon - 1024x1024 (for .icon file)") {
    AppIconView()
        .frame(width: 1024, height: 1024)
}

#Preview("App Icon - Large Preview") {
    AppIconView()
        .frame(width: 800, height: 800)
}

#Preview("App Icon - Small Preview") {
    AppIconView()
        .frame(width: 400, height: 400)
}
