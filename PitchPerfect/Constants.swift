//
//  Constants.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 14/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import Foundation

// As demonstrated in this article: https://github.com/raywenderlich/swift-style-guide#constants
// The use of case-less enums is an advantage because it can't accidentally be instantiated (like a struct)
// and works as a pure namespace.

enum FileNames {
    static let RecordedAudio = "recordedAudio.wav"
}

enum SegueIdentifiers {
    static let StopRecording = "stopRecordingSegue"
}

enum RecordingMessages {
    static let NotRecording = "Tap to record"
    static let Recording = "Recording in progress..."
    static let Stopped = "Saving recorded audio..."
    static let FinishRecording = "Success!"
    static let Error = "An error occured when recording. Please tap to record again."
}

enum Alerts {
    static let DismissAlert = "Dismiss"
    static let RecordingDisabledTitle = "Recording Disabled"
    static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
    static let RecordingFailedTitle = "Recording Failed"
    static let RecordingFailedMessage = "Something went wrong with your recording."
    static let AudioRecorderError = "Audio Recorder Error"
    static let AudioSessionError = "Audio Session Error"
    static let AudioRecordingError = "Audio Recording Error"
    static let AudioFileError = "Audio File Error"
    static let AudioEngineError = "Audio Engine Error"
}
