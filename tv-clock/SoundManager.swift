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
    
    init() {
        // Configure audio session to allow mixing with other audio (like Music app)
        #if os(iOS) || os(tvOS) || os(watchOS)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        #endif
    }
    
    func playTriumphSound() {
        // Play "Fanfare" system sound
        playSystemSound(1324) // Fanfare - triumphant celebratory sound
    }
    
    func playButtonToggleSound(enabled: Bool) {
        if enabled {
            // Play a delightful positive sound when enabling
            playSystemSound(1054) // Positive "bloom" chirp
        } else {
            // Play a gentle sound when disabling
            playSystemSound(1306) // Gentle tap
        }
    }
    
    func playButtonNavigationSound() {
        // Play a friendly tick sound when navigating between buttons
        playSystemSound(1123) // Gentle navigation tick
    }
    
    func playResetSound() {
        // Play a "fresh start" swoosh sound
        playSystemSound(1102) // Swoosh/reset sound
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
