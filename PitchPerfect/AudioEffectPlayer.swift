//
//  AudioEffectPlayer.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 18/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioEffectPlayerDelegate {
    func audioPlayerDidStop(_ audioPlayer: AudioEffectPlayer)
    func audioPlayer(_ audioPlayer: AudioEffectPlayer, didFailWithError error: AudioEffectPlayerError)
}

enum AudioEffectPlayerError: Error {
    case FileError, PlayingError
}

final class AudioEffectPlayer {
    
    fileprivate let id = UUID().uuidString
    
    private var file: AVAudioFile
    private var engine: AVAudioEngine!
    
    private var stopTimer = Timer()
    private var stopTimerCount = 0
    
    private var audioRate: Float?
    
    var delegate: AudioEffectPlayerDelegate?

    
    init?(fileUrl: URL, delegate: AudioEffectPlayerDelegate) {
        self.delegate = delegate
        
        do {
            try file = AVAudioFile(forReading: fileUrl)
        } catch {
            return nil
        }
    }
    
    
    // MARK: - Player Functions
    
    func play(withEffect effect: AudioEffect) {
        
        engine = AVAudioEngine()
        
        attachNodes(effect: effect)
        connect(nodes(forEffect: effect))
        scheduleAudio(atTime: nil, rate: effect.rate)
        
        audioRate = effect.rate
        
        do {
            try engine.start()
        } catch {
            if let delegate = delegate {
                delegate.audioPlayer(self, didFailWithError: .PlayingError)
            }
            
            return
        }
        
        audioPlayerNode.play()
    }
    
    func stop() {
        
        stopTimer.invalidate()
        
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
        
        if let delegate = delegate {
            delegate.audioPlayerDidStop(self)
        }
    }
    
    
    // MARK: - Audio Nodes
    
    private let audioPlayerNode = AVAudioPlayerNode()
    private var changeRatePitchNode = AVAudioUnitTimePitch()
    private var echoNode = AVAudioUnitDistortion()
    private var reverbNode = AVAudioUnitReverb()
    
    
    // MARK: - Attach Nodes
    
    private func attachNodes(effect: AudioEffect) {
        engine.attach(audioPlayerNode)
        
        if let rate = effect.rate {
            changeRatePitchNode.rate = rate
        }
        
        if let pitch = effect.pitch {
            changeRatePitchNode.pitch = pitch
        }
        engine.attach(changeRatePitchNode)
        
        echoNode.loadFactoryPreset(.multiEcho1)
        engine.attach(echoNode)
        
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        engine.attach(reverbNode)
    }
    
    
    // MARK: - Connect Nodes
    
    private func nodes(forEffect effect: AudioEffect) -> [AVAudioNode] {
        var nodes = [AVAudioNode]()
        
        if effect.isEchoEnabled && effect.isReverbEnabled {
            nodes = [audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, engine.outputNode]
        } else if effect.isEchoEnabled {
            nodes = [audioPlayerNode, changeRatePitchNode, echoNode, engine.outputNode]
        } else if effect.isReverbEnabled {
            nodes = [audioPlayerNode, changeRatePitchNode, reverbNode, engine.outputNode]
        } else {
            nodes = [audioPlayerNode, changeRatePitchNode, engine.outputNode]
        }
        
        return nodes
    }
    
    private func connect(_ nodes: [AVAudioNode]) {
        for i in 0 ..< nodes.count - 1 {
            engine.connect(nodes[i], to: nodes[i + 1], format: file.processingFormat)
        }
    }
    
    
    // MARK: - Schedule Audio File to Play
    
    private func scheduleAudio(atTime: AVAudioTime?, rate: Float?) {
        audioPlayerNode.stop()
        
        audioPlayerNode.scheduleFile(file, at: atTime) {
            
            let delay = self.audioRemainingTime(rate: rate)
            self.configureStopTimer(withInterval: delay)
        }
    }
    
    private func audioRemainingTime(rate: Float?) -> TimeInterval {
        var remaining = 0.0
        
        if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
            
            if let rate = rate {
                remaining = Double(self.file.length - playerTime.sampleTime) / Double(self.file.processingFormat.sampleRate) / Double(rate)
            } else {
                remaining = Double(self.file.length - playerTime.sampleTime) / Double(self.file.processingFormat.sampleRate)
            }
        }
        
        return remaining
    }
    
    private func configureStopTimer(withInterval interval: TimeInterval) {
        
        DispatchQueue.main.async {
            self.stopTimer = Timer(timeInterval: interval, target: self, selector: #selector(self.timerDidFire(_:)), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer, forMode: .defaultRunLoopMode)
        }
    }
    
    @objc private func timerDidFire(_ timer: Timer) {
        
        stop()
    }
}

extension AudioEffectPlayer: Equatable {
    
    static func ==(lhs: AudioEffectPlayer, rhs: AudioEffectPlayer) -> Bool {
        return lhs.id == rhs.id
    }
}
