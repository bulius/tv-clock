//
//  AppIconGenerator.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/8/26.
//

import SwiftUI

/// This view can be used to generate the app icon
/// Export this view at the required sizes for tvOS app icons
/// 
/// To use this:
/// 1. Run the app in a Simulator or Preview
/// 2. Take screenshots at these sizes for tvOS:
///    - 400x240 (Top Shelf Image)
///    - 1280x768 (Top Shelf Image @2x)
///    - 2320x720 (Top Shelf Image Wide)
///    - 4640x1440 (Top Shelf Image Wide @2x)
///    - App Icon (tvOS): 400x400, 800x800, 1280x768, 2560x1536
struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient similar to Apple TV Music app
            // The Music app icon uses a vibrant red-pink gradient
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.24, blue: 0.42),  // Hot pink
                    Color(red: 0.92, green: 0.18, blue: 0.35)   // Deep pink-red
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Glass texture overlay
            RadialGradient(
                colors: [
                    Color.white.opacity(0.2),
                    Color.white.opacity(0.0)
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
            
            // Sparkles icon with glass material effect
            ZStack {
                // Glow layer
                Image(systemName: "sparkles")
                    .font(.system(size: 280, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 8)
                    .opacity(0.6)
                
                // Main sparkles with glass effect
                Image(systemName: "sparkles")
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
                    .shadow(color: .white.opacity(0.8), radius: 15, x: -3, y: -3)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
                
                // Highlight for glass effect
                Image(systemName: "sparkles")
                    .font(.system(size: 280, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .offset(x: -2, y: -2)
            }
        }
        .frame(width: 400, height: 400)
    }
}

// Preview for the icon at different sizes
#Preview("App Icon - 400x400") {
    AppIconView()
        .frame(width: 400, height: 400)
}

#Preview("App Icon - 800x800") {
    AppIconView()
        .frame(width: 800, height: 800)
}

#Preview("App Icon - Small") {
    AppIconView()
        .frame(width: 200, height: 200)
}
