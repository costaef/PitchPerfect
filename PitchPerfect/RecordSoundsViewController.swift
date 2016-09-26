//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 14/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    
    enum ViewState {
        case NotRecording, Recording, Stopped, FinishRecording, Error
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update(viewState: .NotRecording)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the recorded audio URL to the play sounds view controller.
        
        if segue.identifier == SegueIdentifiers.StopRecording {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            playSoundsVC.fileUrl = sender as? URL
        }
    }
    
    
    // MARK: - Actions

    @IBAction func recordButtonTouch(_ sender: UIButton) {
        
        audioRecorder = makeAudioRecorder(fileName: FileNames.RecordedAudio)
        
        if let audioRecorder = audioRecorder {
            update(viewState: .Recording)
            start(audioRecorder)
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        if let audioRecorder = audioRecorder {
            update(viewState: .Stopped)
            stop(audioRecorder)
        } else {
            update(viewState: .Error)
        }
    }
    
    
    // MARK: - UI Configuration
    
    func update(viewState state: ViewState) {
        switch state {
        case .NotRecording:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.NotRecording
        case .Recording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = true
            self.recordLabel.text = RecordingMessages.Recording
        case .Stopped:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.Stopped
        case .FinishRecording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.FinishRecording
        case .Error:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.Error
        }
    }
}



