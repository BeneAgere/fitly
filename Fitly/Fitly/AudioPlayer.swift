//
//  AudioPlayer.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on 2/20/25.
//

import Foundation



import Foundation
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidFinishPlaying()
    func didUpdateAudioProgress(currentTime: TimeInterval, duration: TimeInterval)
}

public class AudioPlayer: NSObject, ObservableObject {
    @Published public var isPlaying = false
    @Published private(set) public var audioPlayerError = false
    @Published public var audioLevels: [CGFloat] = []
    private let audioSession = AVAudioSession.sharedInstance()
    private let audioLevelCount = 30
    weak var delegate: AudioPlayerDelegate?
    
    private var audioPlayer: AVAudioPlayer?
    private var levelTimer: Timer?
    
    public func playAudio(from data: Data) {
        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try audioSession.setMode(.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.overrideOutputAudioPort(.speaker)
            
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            
            levelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateAudioLevels()
                self?.updateAudioProgress()
            }
            
        } catch {
            audioPlayerError = true
        }
    }
    
    
    private func updateAudioProgress() {
        guard let player = audioPlayer else { return }
        let currentTime = player.currentTime
        let duration = player.duration
        
        delegate?.didUpdateAudioProgress(currentTime: currentTime, duration: duration)
    }
    // Second option
    public func playAudio2(from string: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: string)
        
        // Set voice properties if needed
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = 0.5 // Adjust rate if needed
        speechUtterance.pitchMultiplier = 1.0 // Adjust pitch if needed
        
        // Start speaking the string
        speechSynthesizer.speak(speechUtterance)
    }
    
    
    public func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        levelTimer?.invalidate()
        levelTimer = nil
        isPlaying = false
        audioLevels.removeAll()
    }
    
    private func updateAudioLevels() {
        guard let player = audioPlayer, player.isPlaying else { return }
        
        player.updateMeters()
        let level = CGFloat(player.averagePower(forChannel: 0))
        let normalizedLevel = pow(10, level / 20)
        
        DispatchQueue.main.async {
            self.audioLevels.append(normalizedLevel)
            if self.audioLevels.count > self.audioLevelCount {
                self.audioLevels.removeFirst()
            }
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.stopPlaying()
            self.delegate?.audioPlayerDidFinishPlaying()
        }
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async {
            self.audioPlayerError = true
            self.stopPlaying()
        }
    }
}
