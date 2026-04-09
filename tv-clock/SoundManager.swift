//
//  SoundManager.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/8/26.
//

import AVFoundation
import SwiftUI

@Observable
class SoundManager {
    private var audioPlayer: AVAudioPlayer?
    
    func playTriumphSound() {
        // Play success/triumph sound
        playSystemSound(1013) // Success/bell sound
    }
    
    func playButtonToggleSound(enabled: Bool) {
        if enabled {
            // Play a positive/confirmation sound when enabling
            playSystemSound(1057) // Positive chirp
        } else {
            // Play a subtle sound when disabling
            playSystemSound(1104) // Subtle click
        }
    }
    
    func playButtonNavigationSound() {
        // Play a subtle tick sound when navigating between buttons
        playSystemSound(1104) // Camera shutter/tick sound
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
        
        // For custom sound files, you would use:
        // guard let soundURL = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
        // do {
        //     audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        //     audioPlayer?.play()
        // } catch {
        //     print("Failed to play sound: \(error)")
        // }
    }
}
