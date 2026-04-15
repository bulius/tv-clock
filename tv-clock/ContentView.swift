//
//  ContentView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import SwiftUI
#if os(macOS)
import IOKit.pwr_mgt
#endif

struct ContentView: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @State private var overrideColorScheme: ColorScheme?
    @State private var weatherManager = WeatherManager()
    @State private var buttonStates: [Bool] = Array(repeating: false, count: 5)
    @State private var showConfetti = false
    @State private var confettiTrigger = 0
    @State private var hasAppeared = false
    @State private var selectedButtonIndex: Int = 0
    @State private var celebrationMessage: String = ""
    @State private var showMessage = false
    @State private var buttonScales: [CGFloat] = Array(repeating: 1.0, count: 5)
    @State private var buttonRotations: [Double] = Array(repeating: 0.0, count: 5)
    @State private var showSparkles: [Bool] = Array(repeating: false, count: 5)
    @State private var isAnimatingCountdown = false
    @State private var animatedCountdownValue: String = ""
    @State private var countdownAnimationTask: Task<Void, Never>?
    @State private var isOverdue = false
    private let soundManager = SoundManager()
    
    // Computed property to get the active color scheme
    private var colorScheme: ColorScheme {
        overrideColorScheme ?? systemColorScheme
    }

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
    
    // Button icons and labels for AM Timer (before noon)
    private let amButtonIcons = [
        "tshirt.fill",      // Get Dressed
        "shoe.fill",        // Put on Shoes
        "face.smiling",     // Brush Teeth
        "comb.fill",        // Brush Hair
        "toilet.fill"       // Use Bathroom
    ]
    
    private let amButtonLabels = [
        "Get Dressed",
        "Put on Shoes",
        "Brush Teeth",
        "Brush Hair",
        "Potty"
    ]
    
    // Button icons and labels for PM Timer (after noon)
    private let pmButtonIcons = [
        "tshirt.fill",      // Get Dressed
        "pills.fill",       // Vitamins
        "face.smiling",     // Brush Teeth
        "toilet.fill",      // Use Bathroom
        "fork.knife"            // Snack
    ]
    
    private let pmButtonLabels = [
        "Get Dressed",
        "Vitamins",
        "Brush Teeth",
        "Potty",
        "Snack"
    ]

    // Computed properties to get current icons and labels based on time of day
    private var buttonIcons: [String] {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? amButtonIcons : pmButtonIcons
    }
    
    private var buttonLabels: [String] {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? amButtonLabels : pmButtonLabels
    }
    
    // Encouraging messages for different completion stages
    private let encouragingMessages = [
        "Great start! Keep going! 🌟",
        "You're doing awesome! 🎉",
        "Amazing! Almost done! 🚀",
        "Wow! Just one more! 💪",
        "ALL DONE! You're a superstar! 🎊🌈✨"
    ]
    
    // Rainbow colors matching Apple HIG - high saturation
    private let buttonColors: [Color] = [
        Color(red: 1.0, green: 0.231, blue: 0.188),    // Vibrant Red
        Color(red: 1.0, green: 0.584, blue: 0.0),      // Vibrant Orange
        Color(red: 1.0, green: 0.8, blue: 0.0),        // Vibrant Yellow
        Color(red: 0.298, green: 0.851, blue: 0.392),  // Vibrant Green
        Color(red: 0.0, green: 0.478, blue: 1.0)       // Vibrant Blue
    ]
    
    // Calculate countdown to target time (7:30 AM or 8:00 PM based on current time)
    private func timeUntilTarget(from date: Date) -> (timeString: String, isOverdue: Bool) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        // Determine which timer to use based on current time
        let (targetHour, targetMinute): (Int, Int)
        if hour < 12 {
            // Before noon: use AM Timer (7:30 AM)
            targetHour = 7
            targetMinute = 30
        } else {
            // After noon: use PM Timer (8:00 PM)
            targetHour = 20  // 8 PM in 24-hour format
            targetMinute = 0
        }
        
        var targetComponents = calendar.dateComponents([.year, .month, .day], from: date)
        targetComponents.hour = targetHour
        targetComponents.minute = targetMinute
        targetComponents.second = 0
        
        guard let targetDate = calendar.date(from: targetComponents) else {
            return ("00:00:00", false)
        }
        
        // If target time has passed, we're counting up (overdue)
        let timeInterval = targetDate.timeIntervalSince(date)
        
        if timeInterval <= 0 {
            // Past target time - count up and mark as overdue
            let elapsedInterval = abs(timeInterval)
            let hours = Int(elapsedInterval) / 3600
            let minutes = (Int(elapsedInterval) % 3600) / 60
            let seconds = Int(elapsedInterval) % 60
            return (String(format: "%02d:%02d:%02d", hours, minutes, seconds), true)
        } else {
            // Before target time - count down
            let hours = Int(timeInterval) / 3600
            let minutes = (Int(timeInterval) % 3600) / 60
            let seconds = Int(timeInterval) % 60
            return (String(format: "%02d:%02d:%02d", hours, minutes, seconds), false)
        }
    }

    var body: some View {
        ZStack {
            // Background
            palette.gradient(for: colorScheme)
                .animation(.easeInOut(duration: 1.0), value: weatherManager.condition)
                .animation(.easeInOut(duration: 0.5), value: colorScheme)
            
            // Confetti layer (behind clock and buttons)
            if showConfetti {
                ConfettiView()
                    .id(confettiTrigger)
            }
            
            // macOS-only controls (top corners)
            #if os(macOS)
            VStack {
                HStack {
                    remoteControl()
                    Spacer()
                    colorSchemeToggleButton()
                }
                Spacer()
            }
            .padding(40)
            #endif
            
            // Main content (clock and buttons)
            GeometryReader { geometry in
                let fontSize = geometry.size.width / Self.totalWidthPerFontSize
                let padding = fontSize * Self.gapPerFontSize
                
                VStack(spacing: 0) {
                    // Countdown Timer with fast animation when transitioning
                    if isAnimatingCountdown {
                        // Show animated countdown
                        Text(animatedCountdownValue)
                            .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .lineLimit(1)
                            .padding(.horizontal, padding)
                            .contentTransition(.numericText(value: Double(parseTimeString(animatedCountdownValue))))
                            .animation(.linear(duration: 0.016), value: animatedCountdownValue)
                            .scaleEffect(hasAppeared ? 1.0 : 0.5)
                            .opacity(hasAppeared ? 1.0 : 0.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0),
                                value: hasAppeared
                            )
                    } else if allButtonsEnabled {
                        // Show static "00:00:00" when all tasks complete
                        Text("00:00:00")
                            .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
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
                            let result = timeUntilTarget(from: context.date)
                            let countdown = result.timeString
                            let overdue = result.isOverdue
                            
                            Text(countdown)
                                .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                                .foregroundStyle(overdue ? Color.red : (colorScheme == .dark ? Color.white : Color.black))
                                .lineLimit(1)
                                .padding(.horizontal, padding)
                                .contentTransition(.numericText(value: Double(parseTimeString(countdown))))
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: countdown)
                                .opacity(overdue ? (context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 2) < 1 ? 1.0 : 0.3) : 1.0)
                                .animation(.linear(duration: 0.5), value: context.date.timeIntervalSince1970)
                                .scaleEffect(hasAppeared ? 1.0 : 0.5)
                                .opacity(hasAppeared ? (overdue ? (context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 2) < 1 ? 1.0 : 0.3) : 1.0) : 0.0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0),
                                    value: hasAppeared
                                )
                        }
                    }
                    
                    // Buttons
                    HStack(spacing: padding) {
                        ForEach(0..<5, id: \.self) { index in
                            routineButton(index: index, fontSize: fontSize, padding: padding)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, padding)
                    .padding(.top, padding * 0.5)
                    .frame(height: (geometry.size.width - (padding * 2) - (padding * 4)) / 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            weatherManager.start()
            // Trigger the bounce-in animation
            withAnimation {
                hasAppeared = true
            }
            
            // Disable screen sleep/screensaver
            #if os(macOS)
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = false
            // Prevent display sleep
            var assertionID: IOPMAssertionID = 0
            IOPMAssertionCreateWithName(
                kIOPMAssertionTypeNoDisplaySleep as CFString,
                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                "TV Clock App Running" as CFString,
                &assertionID
            )
            #elseif os(iOS) || os(tvOS)
            UIApplication.shared.isIdleTimerDisabled = true
            #endif
        }
        .onDisappear {
            // Re-enable screen sleep/screensaver when app closes
            #if os(iOS) || os(tvOS)
            UIApplication.shared.isIdleTimerDisabled = false
            #endif
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func remoteControl() -> some View {
        let buttonColor = colorScheme == .dark ? Color.white : Color.black
        let backgroundColor = colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)
        let disabledColor = colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3)
        
        VStack(spacing: 8) {
            // Up arrow (not used but keeps symmetry)
            Button {
                // No action
            } label: {
                Image(systemName: "chevron.up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(disabledColor)
                    .frame(width: 50, height: 40)
            }
            .buttonStyle(.plain)
            .disabled(true)
            
            // Left, Center, Right
            HStack(spacing: 8) {
                Button {
                    moveSelection(direction: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(buttonColor.opacity(0.8))
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(backgroundColor)
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    toggleButton(at: selectedButtonIndex)
                } label: {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .strokeBorder(buttonColor.opacity(0.6), lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    moveSelection(direction: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(buttonColor.opacity(0.8))
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(backgroundColor)
                        )
                }
                .buttonStyle(.plain)
            }
            
            // Down arrow (not used but keeps symmetry)
            Button {
                // No action
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(disabledColor)
                    .frame(width: 50, height: 40)
            }
            .buttonStyle(.plain)
            .disabled(true)
        }
        .scaleEffect(hasAppeared ? 1.0 : 0.5)
        .opacity(hasAppeared ? 0.7 : 0.0)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)
            .delay(0.8),
            value: hasAppeared
        )
    }
    
    @ViewBuilder
    private func colorSchemeToggleButton() -> some View {
        Button {
            toggleColorScheme()
        } label: {
            Image(systemName: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 50, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? Color.yellow : Color.orange)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                )
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .scaleEffect(hasAppeared ? 1.0 : 0.5)
        .opacity(hasAppeared ? 0.7 : 0.0)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)
            .delay(0.8),
            value: hasAppeared
        )
    }
    
    @ViewBuilder
    private func routineButton(index: Int, fontSize: CGFloat, padding: CGFloat) -> some View {
        Button {
            toggleButton(at: index)
        } label: {
            buttonContent(index: index, fontSize: fontSize)
                #if os(tvOS)
                .padding(fontSize * 0.1)
                #endif
        }
        #if os(tvOS)
        .buttonStyle(.card)
        #else
        .buttonStyle(.plain)
        #endif
        .scaleEffect(hasAppeared ? 1.0 : 0.5)
        .opacity(hasAppeared ? 1.0 : 0.0)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)
            .delay(0.4 + Double(index) * 0.08),
            value: hasAppeared
        )
    }
    
    @ViewBuilder
    private func buttonContent(index: Int, fontSize: CGFloat) -> some View {
        VStack(spacing: fontSize * 0.08) {
            // Main button content (icon only)
            buttonMainContent(index: index, fontSize: fontSize)
            
            // Label below the button
            Text(buttonLabels[index])
                .font(.system(size: fontSize * 0.096, weight: .semibold, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
        }
    }
    
    @ViewBuilder
    private func sparkleEffect(fontSize: CGFloat) -> some View {
        ForEach(0..<8, id: \.self) { sparkleIndex in
            Circle()
                .fill(Color.white)
                .frame(width: fontSize * 0.08, height: fontSize * 0.08)
                .offset(
                    x: cos(Double(sparkleIndex) * .pi / 4) * fontSize * 0.4,
                    y: sin(Double(sparkleIndex) * .pi / 4) * fontSize * 0.4
                )
                .opacity(0.8)
        }
    }
    
    @ViewBuilder
    private func buttonMainContent(index: Int, fontSize: CGFloat) -> some View {
        let circleSize = fontSize * 0.6  // Fixed circle size
        
        Image(systemName: buttonIcons[index])
            .font(.system(size: fontSize * 0.38))
            .foregroundStyle(Color.white)
            .frame(width: circleSize, height: circleSize)
            .background(buttonBackground(index: index, fontSize: fontSize))
            .overlay(focusRing(index: index))
            .scaleEffect(buttonScales[index])
            .rotationEffect(.degrees(buttonRotations[index]))
    }
    
    @ViewBuilder
    private func buttonBackground(index: Int, fontSize: CGFloat) -> some View {
        Circle()
            .fill(buttonStates[index] ? buttonColors[index] : Color.black)
            .shadow(
                color: buttonStates[index] ? buttonColors[index].opacity(0.25) : .clear,
                radius: buttonStates[index] ? fontSize * 0.075 : fontSize * 0.15,
                x: 0,
                y: buttonStates[index] ? fontSize * 0.04 : fontSize * 0.08
            )
    }
    
    @ViewBuilder
    private func focusRing(index: Int) -> some View {
        #if os(macOS)
        if selectedButtonIndex == index {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.white, lineWidth: 8)
                .scaleEffect(1.15)
                .animation(.easeInOut(duration: 0.2), value: selectedButtonIndex)
        }
        #endif
    }
    
    // MARK: - Actions
    
    private func toggleColorScheme() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if overrideColorScheme == nil {
                // First toggle: override to opposite of system
                overrideColorScheme = systemColorScheme == .dark ? .light : .dark
            } else if overrideColorScheme == systemColorScheme {
                // Currently matching system, toggle to opposite
                overrideColorScheme = systemColorScheme == .dark ? .light : .dark
            } else {
                // Currently opposite of system, reset to follow system
                overrideColorScheme = nil
            }
        }
        soundManager.playButtonNavigationSound()
    }
    
    private func moveSelection(direction: Int) {
        soundManager.playButtonNavigationSound()
        selectedButtonIndex = (selectedButtonIndex + direction + 5) % 5
    }
    
    private func toggleButton(at index: Int) {
        let wasAllEnabled = allButtonsEnabled
        buttonStates[index].toggle()
        
        if buttonStates[index] {
            // Enabling - celebrate!
            celebrateButtonPress(at: index)
            
            // Show encouraging message
            let completedCount = buttonStates.filter { $0 }.count
            celebrationMessage = encouragingMessages[min(completedCount - 1, encouragingMessages.count - 1)]
            showMessage = true
            
            // Hide message after delay (except for final message)
            if completedCount < 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        showMessage = false
                    }
                }
            }
        } else {
            // Disabling - just play sound
            soundManager.playButtonToggleSound(enabled: false)
            
            // Hide message if unchecking
            withAnimation {
                showMessage = false
            }
        }
        
        // Check if all buttons are now enabled
        if !wasAllEnabled && allButtonsEnabled {
            // Start countdown animation to 00:00:00
            animateCountdownToZero()
            triggerCelebration()
        } else if wasAllEnabled && !allButtonsEnabled {
            // Reverting from all enabled - animate back to current time
            animateCountdownFromZero()
        }
    }
    
    private func celebrateButtonPress(at index: Int) {
        // Play toggle sound
        soundManager.playButtonToggleSound(enabled: true)
        
        // Big bounce animation with more spring
        withAnimation(.spring(response: 0.5, dampingFraction: 0.4)) {
            buttonScales[index] = 1.5
        }
        
        // Return to normal size with overshoot
        withAnimation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.15)) {
            buttonScales[index] = 1.0
        }
        
        // Add a bigger rotation wiggle
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            buttonRotations[index] = 15
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.15)) {
            buttonRotations[index] = -15
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.3)) {
            buttonRotations[index] = 0
        }
    }
    
    private func resetButtons() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            buttonStates = Array(repeating: false, count: 5)
            showMessage = false
            celebrationMessage = ""
        }
        soundManager.playResetSound()
        
        // Reset all button states
        buttonScales = Array(repeating: 1.0, count: 5)
        buttonRotations = Array(repeating: 0.0, count: 5)
        showSparkles = Array(repeating: false, count: 5)
    }
    
    private func triggerCelebration() {
        // Play triumphant sound
        soundManager.playTriumphSound()
        
        // Show confetti
        showConfetti = true
        confettiTrigger += 1
        
        // Hide confetti after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            showConfetti = false
        }
    }
    
    // MARK: - Countdown Animation
    
    /// Animates countdown from current time to 00:00:00
    private func animateCountdownToZero() {
        // Cancel any existing animation
        countdownAnimationTask?.cancel()
        
        let result = timeUntilTarget(from: .now)
        let currentTime = result.timeString
        let startSeconds = parseTimeString(currentTime)
        
        guard startSeconds > 0 else {
            return
        }
        
        isAnimatingCountdown = true
        animatedCountdownValue = currentTime
        
        countdownAnimationTask = Task {
            // Faster animation - complete in ~0.4 seconds at 60fps
            let totalFrames = 24
            let secondsPerFrame = max(1, startSeconds / totalFrames)
            
            var remainingSeconds = startSeconds
            
            while remainingSeconds > 0 {
                guard !Task.isCancelled else { break }
                
                remainingSeconds = max(0, remainingSeconds - secondsPerFrame)
                
                await MainActor.run {
                    animatedCountdownValue = formatSeconds(remainingSeconds)
                }
                
                // ~16ms per frame for smooth 60fps animation
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
            
            await MainActor.run {
                animatedCountdownValue = "00:00:00"
                
                // Small delay before clearing animation state
                Task {
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    await MainActor.run {
                        isAnimatingCountdown = false
                    }
                }
            }
        }
    }
    
    /// Animates countdown from 00:00:00 to current time
    private func animateCountdownFromZero() {
        // Cancel any existing animation
        countdownAnimationTask?.cancel()
        
        let result = timeUntilTarget(from: .now)
        let targetTime = result.timeString
        let endSeconds = parseTimeString(targetTime)
        
        guard endSeconds > 0 else {
            return
        }
        
        isAnimatingCountdown = true
        animatedCountdownValue = "00:00:00"
        
        countdownAnimationTask = Task {
            // Faster animation - complete in ~0.4 seconds
            let totalFrames = 24
            let secondsPerFrame = max(1, endSeconds / totalFrames)
            
            var currentSeconds = 0
            
            while currentSeconds < endSeconds {
                guard !Task.isCancelled else { break }
                
                currentSeconds = min(endSeconds, currentSeconds + secondsPerFrame)
                
                await MainActor.run {
                    animatedCountdownValue = formatSeconds(currentSeconds)
                }
                
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
            
            await MainActor.run {
                animatedCountdownValue = targetTime
                
                // Small delay before clearing animation state
                Task {
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    await MainActor.run {
                        isAnimatingCountdown = false
                    }
                }
            }
        }
    }
    
    /// Parse time string (HH:mm:ss) into total seconds
    private func parseTimeString(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 3 else { return 0 }
        return components[0] * 3600 + components[1] * 60 + components[2]
    }
    
    /// Format seconds into HH:mm:ss string
    private func formatSeconds(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    ContentView()
}
