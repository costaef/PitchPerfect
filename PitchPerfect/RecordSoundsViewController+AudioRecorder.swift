//
//  RecordSoundsViewController+AudioRecorder.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 19/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import UIKit
import AVFoundation

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
