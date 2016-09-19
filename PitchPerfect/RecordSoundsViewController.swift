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
    
    enum RecordingState {
        case NewRecord, Recording, Stopped, FinishRecording, Error
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(recordingState: .NewRecord)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the recorded audio URL to the play sounds view controller.
        
        if segue.identifier == SegueIdentifiers.stopRecordingSegueIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            playSoundsVC.recordedAudioFileUrl = sender as? URL
        }
    }
    
    
    // MARK: - Actions

    @IBAction func recordButtonTouch(_ sender: UIButton) {
        
        audioRecorder = createAudioRecorder(fileName: FileNames.recordedAudioFileName)
        
        if let audioRecorder = audioRecorder {
            configureUI(recordingState: .Recording)
            startRecordingAudio(audioRecorder: audioRecorder)
        }
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        if let audioRecorder = audioRecorder {
            configureUI(recordingState: .Stopped)
            stopRecordingAudio(audioRecorder: audioRecorder)
        } else {
            configureUI(recordingState: .Error)
        }
    }
    
    
    // MARK: - UI Configuration
    
    func configureUI(recordingState: RecordingState) {
        switch recordingState {
        case .NewRecord:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.newRecord
        case .Recording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = true
            self.recordLabel.text = RecordingMessages.recording
        case .Stopped:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.stopped
        case .FinishRecording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.finishRecording
        case .Error:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = RecordingMessages.error
        }
    }
}



