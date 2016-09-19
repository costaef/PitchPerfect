//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 14/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import UIKit

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioFileUrl: URL? = nil
    
    enum PlayButtonType: Int {
        case Snail = 0, Rabbit, Chipmunk, DarthVader, Echo, Reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(recordedAudioFileUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func playButtonTouch(_ sender: UIButton) {
        print("Play Button with Tag: \(sender.tag)")
        
        if let playButtonType = PlayButtonType(rawValue: sender.tag) {
            let audioPlayer = AudioEffectPlayer(audioFileUrl: recordedAudioFileUrl!)
            
            switch playButtonType {
            case .Snail:
                audioPlayer.play(withAudioEffect: .snailEffect)
            case .Rabbit:
                audioPlayer.play(withAudioEffect: .rabbitEffect)
            case .Chipmunk:
                audioPlayer.play(withAudioEffect: .chipmunkEffect)
            case .DarthVader:
                audioPlayer.play(withAudioEffect: .darthVaderEffect)
            case .Echo:
                audioPlayer.play(withAudioEffect: .echoEffect)
            case .Reverb:
                audioPlayer.play(withAudioEffect: .reverbEffect)
            }
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        print("Stop Button...")
    }
}
