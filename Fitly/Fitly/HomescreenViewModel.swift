//
//  VoiceChatViewModel.swift
//
//  Created by angel zambrano on 2/22/25.
//

import Foundation
import Combine

enum VoiceModeStatus {
    case recording
    case translating
    case playing
    case aiThinking
    case none
}


@MainActor
class HomescreenViewModel: ObservableObject, AudioPlayerDelegate {
    
    @Published var voiceModeStatus: VoiceModeStatus = .none
    private let audioService = AudioService()
    private let audioPlayer = AudioPlayer()
    private var cancellables = Set<AnyCancellable>()
    
    func audioPlayerDidFinishPlaying() {
        //
    }
    
    func didUpdateAudioProgress(currentTime: TimeInterval, duration: TimeInterval) {
        //
    }
    
    func playResponse(_ audioData: Data) {
        audioPlayer.playAudio(from: audioData)
    }
    
    
    
    
}
