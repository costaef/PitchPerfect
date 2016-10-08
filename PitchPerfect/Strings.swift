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
    static let Disabled = "Record Permission Denied"
    static let Error = "An error occured while recording. Please tap to record again"
}

enum AlertActions {
    static let Dismiss = "Dismiss"
}

enum AlertTitles {
    static let AudioSessionError = "Audio Session Error"
    static let RecordingDisabled = "Recording Disabled"
    static let AudioRecorderError = "Audio Recorder Error"
    static let RecordingFailed = "Recording Failed"
    static let AudioFileNil = "Audio File Error"
    static let AudioFileError = "Audio File Error"
    static let AudioEngineError = "Audio Engine Error"
}

enum AlertMessages {
    static let AudioSessionError = "Something went wrong with your recording. Please try to record again."
    static let RecordingDisabled = "You've disabled this app from recording your microphone. Check Settings > Privacy > Microphone."
    static let AudioRecorderError = "Something went wrong with your recording. Please try to record again."
    static let RecordingFailed = "Something went wrong with your recording. Please try to record again."
    static let AudioFileNil = "The audio file was not found."
    static let AudioFileError = "Something went wrong with the recorded audio file."
    static let AudioEngineError = "The audio player could not play the file."
}
