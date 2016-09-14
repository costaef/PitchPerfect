//
//  Constants.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 14/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import Foundation

enum Constants: String {
    case recordedAudioFileName = "recordedAudio.wav"
    case stopRecordingSegueIdentifier = "stopRecordingSegue"
}

enum RecordingMessages: String {
    case newRecord = "Tap to record"
    case recording = "Recording in progress..."
    case stopped = "Saving recorded audio..."
    case finishRecording = "Success!"
    case error = "An error occured when recording. Please tap to record again."
}
