//
//  ContentView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var weatherManager = WeatherManager()
    @State private var buttonStates: [Bool] = Array(repeating: false, count: 5)
    @State private var showConfetti = false
    @State private var confettiTrigger = 0
    @State private var hasAppeared = false
    @State private var selectedButtonIndex: Int = 0
    @FocusState private var focusedButton: Int?
    private let soundManager = SoundManager()

    private var palette: WeatherColorPalette {
        .palette(for: weatherManager.condition)
    }
    
    private var allButtonsEnabled: Bool {
        buttonStates.allSatisfy { $0 }
    }

    // Ratios measured from SF Mono Medium glyph metrics at 100pt:
    // - Character cell advance width: 61.82pt
    // - Visual gap (digit right bearing + colon left bearing): 27.78pt
    // - Total width for "HH:mm:ss" (8 cells) + 2 gap-sized paddings: 550.10pt
    // These ratios are constant for any font size since metrics scale linearly.
    private static let gapPerFontSize: CGFloat = 0.27783203125
    private static let totalWidthPerFontSize: CGFloat = 5.5009765625
    
    // Button icons
    private let buttonIcons = [
        "tshirt.fill",      // Clothes
        "shoe.fill",        // Shoes
        "face.smiling",     // Brush Teeth
        "comb.fill",        // Brush Hair
        "toilet.fill"       // Go to the bathroom
    ]
    
    // Rainbow colors matching Apple HIG - high saturation
    private let buttonColors: [Color] = [
        Color(red: 1.0, green: 0.231, blue: 0.188),    // Vibrant Red
        Color(red: 1.0, green: 0.584, blue: 0.0),      // Vibrant Orange
        Color(red: 1.0, green: 0.8, blue: 0.0),        // Vibrant Yellow
        Color(red: 0.298, green: 0.851, blue: 0.392),  // Vibrant Green
        Color(red: 0.0, green: 0.478, blue: 1.0)       // Vibrant Blue
    ]
    
    // Calculate countdown to 7:30 AM
    private func timeUntilTarget(from date: Date) -> String {
        let calendar = Calendar.current
        var targetComponents = calendar.dateComponents([.year, .month, .day], from: date)
        targetComponents.hour = 7
        targetComponents.minute = 30
        targetComponents.second = 0
        
        guard var targetDate = calendar.date(from: targetComponents) else {
            return "00:00:00"
        }
        
        // If target time has passed today, set it for tomorrow
        if targetDate <= date {
            targetDate = calendar.date(byAdding: .day, value: 1, to: targetDate) ?? targetDate
        }
        
        let timeInterval = targetDate.timeIntervalSince(date)
        
        if timeInterval <= 0 {
            return "00:00:00"
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        ZStack {
            // Background
            palette.gradient(for: colorScheme)
                .animation(.easeInOut(duration: 1.0), value: weatherManager.condition)
            
            // Confetti layer (behind clock and buttons)
            if showConfetti {
                ConfettiView()
                    .id(confettiTrigger)
            }
            
            // Main content (clock and buttons)
            GeometryReader { geometry in
                let fontSize = geometry.size.width / Self.totalWidthPerFontSize
                let padding = fontSize * Self.gapPerFontSize
                
                VStack(spacing: 0) {
                    // Countdown Timer - stops when all buttons enabled
                    if allButtonsEnabled {
                        // Show static "00:00:00" when all tasks complete
                        Text("00:00:00")
                            .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .padding(.horizontal, padding)
                            .scaleEffect(hasAppeared ? 1.0 : 0.5)
                            .opacity(hasAppeared ? 1.0 : 0.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0),
                                value: hasAppeared
                            )
                    } else {
                        // Active countdown timer
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            Text(timeUntilTarget(from: context.date))
                                .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .padding(.horizontal, padding)
                                .contentTransition(.numericText())
                                .scaleEffect(hasAppeared ? 1.0 : 0.5)
                                .opacity(hasAppeared ? 1.0 : 0.0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0),
                                    value: hasAppeared
                                )
                        }
                    }
                    
                    // Buttons
                    HStack(spacing: padding) {
                        ForEach(0..<5, id: \.self) { index in
                            Button {
                                toggleButton(at: index)
                            } label: {
                                Image(systemName: buttonIcons[index])
                                    .font(.system(size: fontSize * 0.5))
                                    .foregroundStyle(buttonStates[index] ? .white : .primary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .background(
                                        Circle()
                                            .fill(buttonStates[index] ? buttonColors[index] : .primary)
                                    )
                                    .overlay(
                                        // Highlight ring for focused button
                                        Circle()
                                            .strokeBorder(Color.white, lineWidth: selectedButtonIndex == index ? 6 : 0)
                                            .animation(.easeInOut(duration: 0.2), value: selectedButtonIndex)
                                    )
                            }
                            .buttonStyle(.plain)
                            .focused($focusedButton, equals: index)
                            .scaleEffect(hasAppeared ? 1.0 : 0.5)
                            .opacity(hasAppeared ? 1.0 : 0.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)
                                .delay(0.4 + Double(index) * 0.08),
                                value: hasAppeared
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, padding)
                    .padding(.top, padding)
                    .frame(height: (geometry.size.width - (padding * 2) - (padding * 4)) / 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            weatherManager.start()
            // Trigger the bounce-in animation
            withAnimation {
                hasAppeared = true
            }
            focusedButton = 0
        }
        .focusable()
        .focusEffectDisabled()
        .onMoveCommand { direction in
            switch direction {
            case .left:
                moveSelection(direction: -1)
            case .right:
                moveSelection(direction: 1)
            default:
                break
            }
        }
        #if os(tvOS)
        .onPlayPauseCommand {
            toggleButton(at: selectedButtonIndex)
        }
        .onExitCommand {
            resetButtons()
        }
        #endif
    }
    
    private func moveSelection(direction: Int) {
        soundManager.playButtonNavigationSound()
        selectedButtonIndex = (selectedButtonIndex + direction + 5) % 5
        focusedButton = selectedButtonIndex
    }
    
    private func toggleButton(at index: Int) {
        let wasAllEnabled = allButtonsEnabled
        buttonStates[index].toggle()
        
        // Play toggle sound
        soundManager.playButtonToggleSound(enabled: buttonStates[index])
        
        // Check if all buttons are now enabled
        if !wasAllEnabled && allButtonsEnabled {
            triggerCelebration()
        }
    }
    
    private func resetButtons() {
        buttonStates = Array(repeating: false, count: 5)
        soundManager.playButtonNavigationSound()
    }
    
    private func triggerCelebration() {
        // Play triumphant sound
        soundManager.playTriumphSound()
        
        // Show confetti
        showConfetti = true
        confettiTrigger += 1
        
        // Hide confetti after animation completes (slower fall = longer duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            showConfetti = false
        }
    }
}

#Preview {
    ContentView()
}
