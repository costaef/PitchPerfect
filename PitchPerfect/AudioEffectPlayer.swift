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
    func audioPlayerDidStopPlaying(_ audioPlayer: AudioEffectPlayer)
}

class AudioEffectPlayer {
    
    private lazy var audioFile = AVAudioFile()
    private var audioEngine = AVAudioEngine()
    
    private var stopTimer: Timer?
    
    var delegate: AudioEffectPlayerDelegate?
    
    
    init(audioFileUrl: URL) {
        do {
            try audioFile = AVAudioFile(forReading: audioFileUrl)
        } catch {
            // TODO: Handle error
            return
        }
    }
    
    
    // MARK: - Player Functions
    
    func play(withAudioEffect effect: AudioEffect) {
        
        attachAllNodes(rate: effect.rate, pitch: effect.pitch)
        connectAudioNodes(audioNodeList(forEffect: effect))
        scheduleAudioFile(atTime: nil, rate: effect.rate)
        
        do {
            try audioEngine.start()
        } catch {
            // TODO: Handle error
            return
        }
        
        audioPlayerNode.play()
    }
    
    @objc func stopAudio() {
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        if let delegate = delegate {
            delegate.audioPlayerDidStopPlaying(self)
        }
    }
    
    
    // MARK: - Audio Nodes
    
    private let audioPlayerNode = AVAudioPlayerNode()
    private var changeRatePitchNode = AVAudioUnitTimePitch()
    private var echoNode = AVAudioUnitDistortion()
    private var reverbNode = AVAudioUnitReverb()
    
    
    // MARK: - Attach Nodes
    
    private func attachAudioPlayerNode() {
        audioEngine.attach(audioPlayerNode)
    }
    
    private func attachChangeRatePitchNode(rate: Float? = nil, pitch: Float? = nil) {
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        audioEngine.attach(changeRatePitchNode)
    }
    
    private func attachEchoNode() {
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
    }
    
    private func attachReverbNode() {
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
    }
    
    private func attachAllNodes(rate: Float? = nil, pitch: Float? = nil) {
        attachAudioPlayerNode()
        attachChangeRatePitchNode(rate: rate, pitch: pitch)
        attachEchoNode()
        attachReverbNode()
    }
    
    
    // MARK: - Connect Nodes
    
    private func audioNodeList(forEffect effect: AudioEffect) -> [AVAudioNode] {
        var nodeList = [AVAudioNode]()
        
        if effect.isEchoEnabled && effect.isReverbEnabled {
            nodeList = [audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode]
        } else if effect.isEchoEnabled {
            nodeList = [audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode]
        } else if effect.isReverbEnabled {
            nodeList = [audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode]
        } else {
            nodeList = [audioPlayerNode, changeRatePitchNode, audioEngine.outputNode]
        }
        
        return nodeList
    }
    
    private func connectAudioNodes(_ nodes: [AVAudioNode]) {
        for i in 0 ..< nodes.count - 1 {
            audioEngine.connect(nodes[i], to: nodes[i + 1], format: audioFile.processingFormat)
        }
    }
    
    
    // MARK: - Schedule Audio File to Play
    
    private func scheduleAudioFile(atTime: AVAudioTime?, rate: Float?) {
        audioPlayerNode.stop()
        
        audioPlayerNode.scheduleFile(audioFile, at: atTime) {
            var delayInSeconds = 0.0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: .defaultRunLoopMode)
        }
    }
}
