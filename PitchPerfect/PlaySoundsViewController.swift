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
    
    var fileUrl: URL?
    var player: AudioEffectPlayer!
    
    enum PlayButtonType: Int {
        case Snail = 0, Rabbit, Chipmunk, DarthVader, Echo, Reverb
    }
    
    enum PlayingState {
        case Playing
        case NotPlaying
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard fileUrl != nil else {
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
            
            update(playingState: .Playing)
            
            player = AudioEffectPlayer(fileUrl: fileUrl!)
            player.delegate = self
            
            switch playButtonType {
            case .Snail:
                player.play(withEffect: .snail)
            case .Rabbit:
                player.play(withEffect: .rabbit)
            case .Chipmunk:
                player.play(withEffect: .chipmunk)
            case .DarthVader:
                player.play(withEffect: .darthVader)
            case .Echo:
                player.play(withEffect: .echo)
            case .Reverb:
                player.play(withEffect: .reverb)
            }
        } else {
            // TODO: Handle error
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        player.stop()
    }
    
    
    // MARK: - Configure UI
    
    func update(playingState: PlayingState) {
        switch playingState {
        case .Playing:
            enablePlayButtons(false)
            stopButton.isEnabled = true
        case .NotPlaying:
            enablePlayButtons(true)
            stopButton.isEnabled = false
        }
    }
    
    func enablePlayButtons(_ enabled: Bool) {
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
        update(playingState: .NotPlaying)
    }
}
