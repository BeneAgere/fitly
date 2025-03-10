//
//  AudioService.swift
//
//  Created by angel zambrano on
//


import Foundation
import AVFoundation
import Speech

public class AudioService: NSObject, ObservableObject {
    @Published public var isRecording = false
    @Published public var transcript = ""
    @Published public var audioLevels: [CGFloat] = []
    @Published private(set) public var audioEngineError: Bool = false
    
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioSession = AVAudioSession.sharedInstance()
    private let audioLevelCount = 30
    
    public override init() {
        super.init()
        setupAudio()
    }
    
    private func setupAudio() {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to setup audio session: \(error)")
            audioEngineError = true
        }
    }
    
    public func startRecording() {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            audioEngineError = true
            return
        }
        
        do {
            audioEngine = AVAudioEngine()
            guard let audioEngine = audioEngine else { return }
            
            let inputNode = audioEngine.inputNode
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    self.transcript = result.bestTranscription.formattedString
                    if result.isFinal {
                        self.stopRecording()
                    }
                }
                
                if error != nil {
                    self.stopRecording()
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                guard let self = self else { return }
                recognitionRequest.append(buffer)
                
                let level = self.calculateAudioLevel(buffer)
                DispatchQueue.main.async {
                    self.audioLevels.append(level)
                    if self.audioLevels.count > self.audioLevelCount {
                        self.audioLevels.removeFirst()
                    }
                }
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            
        } catch {
            audioEngineError = true
            print("Failed to start recording: \(error)")
        }
    }
    
    public func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        audioEngine = nil
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        audioLevels.removeAll()
    }
    
    private func calculateAudioLevel(_ buffer: AVAudioPCMBuffer) -> CGFloat {
        guard let channelData = buffer.floatChannelData?[0] else { return 0 }
        let frameLength = UInt32(buffer.frameLength)
        
        var sum: Float = 0
        for i in 0..<Int(frameLength) {
            sum += abs(channelData[i])
        }
        
        let average = sum / Float(frameLength)
        return CGFloat(average)
    }
}
