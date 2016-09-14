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
    
    let recordedAudioFileName = "recordedAudio.wav"
    let stopRecordingSegueIdentifier = "stopRecordingSegue"
    
    enum RecordingState {
        case NewRecord, Recording, Stopped, FinishRecording, Error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == stopRecordingSegueIdentifier {
            //let playSoundsVC = segue.destination as! PlaySoundsViewController
        }
    }
    
    
    // MARK: - Actions

    @IBAction func recordButtonTouch(_ sender: UIButton) {
        
        configureUI(recordingState: .Recording)
        
        audioRecorder = createAudioRecorder(fileName: recordedAudioFileName)
        startRecordingAudio(audioRecorder: audioRecorder!)
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        
        if audioRecorder != nil {
            configureUI(recordingState: .Stopped)
            stopRecordingAudio(audioRecorder: audioRecorder!)
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
            self.recordLabel.text = "Tap to record"
        case .Recording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = true
            self.recordLabel.text = "Recording..."
        case .Stopped:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = "Saving recorded audio..."
        case .FinishRecording:
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.recordLabel.text = "Success!"
        case .Error:
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = "An error occured on recording. Please tap to record again."
        }
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    // MARK: - Audio Recorder
    
    fileprivate func createAudioRecorder(fileName: String) -> AVAudioRecorder {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var filePath = URL(fileURLWithPath: dirPath, isDirectory: true)
        filePath.appendPathComponent(fileName)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        var audioRecorder: AVAudioRecorder
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        
        return audioRecorder
    }
    
    fileprivate func startRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    fileprivate func stopRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            configureUI(recordingState: .FinishRecording)
            performSegue(withIdentifier: stopRecordingSegueIdentifier, sender: self.audioRecorder?.url)
        } else {
            configureUI(recordingState: .Error)
        }
    }
}
