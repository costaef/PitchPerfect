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
    
    func makeAudioRecorder(fileName: String) -> AVAudioRecorder? {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            let alert = Alert(title: AlertTitles.AudioSessionError, message: AlertMessages.AudioSessionError)
            self.showAlert(alert)
            
            return nil
        }
        
        var audioRecorder: AVAudioRecorder?
        
        do {
            try audioRecorder = AVAudioRecorder(url: url(for: fileName), settings: [:])
        } catch {
            let alert = Alert(title: AlertTitles.AudioRecorderError, message: AlertMessages.AudioRecorderError)
            self.showAlert(alert)
            
            return nil
        }
        
        if let audioRecorder = audioRecorder {
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
        }
        
        return audioRecorder
    }
    
    func start(_ audioRecorder: AVAudioRecorder) {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stop(_ audioRecorder: AVAudioRecorder) {
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func url(for fileName: String) -> URL {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var url = URL(fileURLWithPath: directory, isDirectory: true)
        url.appendPathComponent(fileName)
        
        return url
    }
    
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            update(viewState: .FinishRecording)
            performSegue(withIdentifier: SegueIdentifiers.StopRecording, sender: self.audioRecorder?.url)
        } else {
            let alert = Alert(title: AlertTitles.RecordingFailed, message: AlertMessages.RecordingFailed)
            self.showAlert(alert, completion: { 
                DispatchQueue.main.async {
                    self.update(viewState: .Error)
                }
            })
        }
    }
}
