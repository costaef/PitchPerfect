//
//  AudioEffect.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 17/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import Foundation

struct AudioEffect {
    
    var rate: Float?
    var pitch: Float?
    var isEchoEnabled: Bool?
    var isReverbEnabled: Bool?
    
    init(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        self.rate = rate
        self.pitch = pitch
        self.isEchoEnabled = echo
        self.isReverbEnabled = reverb
    }
    
    static var snailEffect: AudioEffect {
        return AudioEffect(rate: 0.5)
    }
    
    static var rabbitEffect: AudioEffect {
        return AudioEffect(rate: 1.5)
    }
    
    static var chipmunkEffect: AudioEffect {
        return AudioEffect(pitch: 1000)
    }
    
    static var darthVaderEffect: AudioEffect {
        return AudioEffect(pitch: -1000)
    }
    
    static var echoEffect: AudioEffect {
        return AudioEffect(echo: true)
    }
    
    static var reverbEffect: AudioEffect {
        return AudioEffect(reverb: true)
    }
}
