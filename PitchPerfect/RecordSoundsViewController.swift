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
        case NotRecording, Recording, Stopped, FinishRecording, Disabled, Error
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
        
        let session = AVAudioSession.sharedInstance()
        
        session.requestRecordPermission { (granted) in
            // Request permission to access the device microphone.
            //
            // If the user had previously granted or denied recording permission, the block executes 
            // immediately and without displaying a recording permission alert.
            //
            // If the user has not yet granted or denied permission the system displays a recording 
            // permission alert and executes the block after the user responds to it.
            
            if granted {
                self.audioRecorder = self.makeAudioRecorder(fileName: FileNames.RecordedAudio)
                
                if let audioRecorder = self.audioRecorder {
                    DispatchQueue.main.async {
                        self.update(viewState: .Recording)
                        self.start(audioRecorder)
                    }
                }
            } else {
                // If the user has denied recording permission, they can reenable it 
                // in Settings > Privacy > Microphone.
                //
                // Show an alert to the user about this procedure.
                
                DispatchQueue.main.async {
                    let alert = Alert(title: AlertTitles.RecordingDisabled, message: AlertMessages.RecordingDisabled)
                    self.showAlert(alert, completion: {
                        DispatchQueue.main.async {
                            self.update(viewState: .Disabled)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        if let audioRecorder = audioRecorder {
            update(viewState: .Stopped)
            stop(audioRecorder)
        } else {
            let alert = Alert(title: AlertTitles.AudioRecorderError, message: AlertMessages.AudioRecorderError)
            self.showAlert(alert, completion: {
                DispatchQueue.main.async {
                    self.update(viewState: .Error)
                }
            })
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
        case .Disabled:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.Disabled
        case .Error:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.Error
        }
    }
}



