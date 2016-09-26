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
    var isEchoEnabled: Bool = false
    var isReverbEnabled: Bool = false
    
    init(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        self.rate = rate
        self.pitch = pitch
        self.isEchoEnabled = echo
        self.isReverbEnabled = reverb
    }
    
    static var snail: AudioEffect {
        return AudioEffect(rate: 0.5)
    }
    
    static var rabbit: AudioEffect {
        return AudioEffect(rate: 1.5)
    }
    
    static var chipmunk: AudioEffect {
        return AudioEffect(pitch: 1000)
    }
    
    static var darthVader: AudioEffect {
        return AudioEffect(pitch: -1000)
    }
    
    static var echo: AudioEffect {
        return AudioEffect(echo: true)
    }
    
    static var reverb: AudioEffect {
        return AudioEffect(reverb: true)
    }
}
