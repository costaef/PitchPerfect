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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions

    @IBAction func recordButtonTouch(_ sender: UIButton) {
        print("Recording...")
        
        self.audioRecorder = createAudioRecorder(fileName: recordedAudioFileName)
        startRecordingAudio(audioRecorder: self.audioRecorder!)
    }
    
    @IBAction func stopButtonTouch(_ sender: UIButton) {
        print("Stop...")
        
        if self.audioRecorder != nil {
            stopRecordingAudio(audioRecorder: self.audioRecorder!)
        }
    }
    
    
    // MARK: - Audio Recorder
    
    private func createAudioRecorder(fileName: String) -> AVAudioRecorder {
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
    
    private func startRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecordingAudio(audioRecorder: AVAudioRecorder) {
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio Recorder did finish recording. Successfully: \(flag)")
    }
}
