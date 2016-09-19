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


extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    // MARK: - Audio Recorder
    
    func createAudioRecorder(fileName: String) -> AVAudioRecorder? {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            // TODO: Error
        }
        
        var audioRecorder: AVAudioRecorder?
        
        do {
            try audioRecorder = AVAudioRecorder(url: audioFileURL(fileName: fileName), settings: [:])
        } catch {
            // TODO: Error
        }
        
        if let audioRecorder = audioRecorder {
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
        }
        
        return audioRecorder
    }
    
    func startRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioFileURL(fileName: String) -> URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var filePath = URL(fileURLWithPath: dirPath, isDirectory: true)
        filePath.appendPathComponent(fileName)
        
        return filePath
    }
    
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            configureUI(recordingState: .FinishRecording)
            performSegue(withIdentifier: SegueIdentifiers.stopRecordingSegueIdentifier, sender: self.audioRecorder?.url)
        } else {
            configureUI(recordingState: .Error)
        }
    }
}
