//
//  Speech.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 3/12/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import Foundation
import Speech

protocol SpeechRecognizerProtocol {

    typealias SpeechRecognizedBlock = (String) -> ()

    func start(contextualStrings: [String]) throws
    func stop()
}

@available(iOS 10.0, *)
class SpeechRecognizer: NSObject, SpeechRecognizerProtocol {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let handler: SpeechRecognizedBlock
    fileprivate(set) var enabled = false

    init(handler: @escaping SpeechRecognizedBlock) {
        self.handler = handler
        super.init()

        speechRecognizer.delegate = self

        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            enabled = true
        } else {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                OperationQueue.main.addOperation {
                    switch authStatus {
                    case .authorized:
                        self.enabled = true

                    case .denied:
                        self.enabled = false

                    case .restricted:
                        self.enabled = false

                    case .notDetermined:
                        self.enabled = false
                    }
                }
            }
        }
    }

    private var contextualStrings: [String]?

    func start(contextualStrings: [String]) throws {
        guard enabled else {
            return
        }

        self.contextualStrings = contextualStrings
        
        // Cancel the previous task if it's running.
        print("START SPEECH")
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        restart()

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        try audioEngine.start()
    }

    @objc func restart() {
//        self.recognitionTask?.finish()

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest

        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.taskHint = .confirmation
        recognitionRequest.shouldReportPartialResults = true
        if let contextualStrings = contextualStrings {
            recognitionRequest.contextualStrings = contextualStrings
        }

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        var recognitionTask: SFSpeechRecognitionTask?
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                if result.isFinal {
                    print("FINISHING")
                    self.handler(result.bestTranscription.formattedString)
                    self.finished()
                } else if !self.finishing {
                    print("SCHEDULING FINISH")
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.finishTask), object: nil)
                    self.perform(#selector(self.finishTask), with: nil, afterDelay: 1)
                } else {
                    print("RESULT WHILE FINISHING")
                }
            }

            print("error=\(error) isFinal=\(result?.isFinal)")

            if error != nil {
                if recognitionTask == self.recognitionTask {
                    print("RESTARTING DUE TO ERROR")
                    self.restart()
                } else {
                    print("Ignore")
                }
            }
        }
        self.recognitionTask = recognitionTask
    }

    private var finishing = false

    @objc private func finishTask() {
        print("FINISH TASK")
        finishing = true
        self.recognitionTask?.finish()
    }

    private func finished() {
        finishing = false
        print("FINISH COMPLETE")
        restart()
    }

    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
}

@available(iOS 10.0, *)
extension SpeechRecognizer: SFSpeechRecognizerDelegate {

    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            enabled = true
        } else {
            enabled = false
        }
    }

}
