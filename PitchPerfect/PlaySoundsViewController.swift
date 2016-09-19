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
    
    var recordedAudioFileUrl: URL?
    var audioPlayer: AudioEffectPlayer!
    
    enum PlayButtonType: Int {
        case Snail = 0, Rabbit, Chipmunk, DarthVader, Echo, Reverb
    }
    
    enum PlayingState {
        case Playing
        case NotPlaying
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard recordedAudioFileUrl != nil else {
            // TODO: Handle error
            return
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func playButtonTouch(_ sender: UIButton) {
        
        if let playButtonType = PlayButtonType(rawValue: sender.tag) {
            
            configureUI(playingState: .Playing)
            
            audioPlayer = AudioEffectPlayer(audioFileUrl: recordedAudioFileUrl!)
            audioPlayer.delegate = self
            
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
        } else {
            // TODO: Handle error
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        audioPlayer.stopAudio()
    }
    
    
    // MARK: - Configure UI
    
    func configureUI(playingState: PlayingState) {
        switch playingState {
        case .Playing:
            playButtons(enabled: false)
            stopButton.isEnabled = true
        case .NotPlaying:
            playButtons(enabled: true)
            stopButton.isEnabled = false
        }
    }
    
    private func playButtons(enabled: Bool) {
        snailButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        darthVaderButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
}

extension PlaySoundsViewController: AudioEffectPlayerDelegate {
    
    func audioPlayerDidStopPlaying(_ audioPlayer: AudioEffectPlayer) {
        configureUI(playingState: .NotPlaying)
    }
}
