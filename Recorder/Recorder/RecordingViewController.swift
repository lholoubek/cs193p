//
//  ViewController.swift
//  Recorder
//
//  Created by Luke Holoubek on 9/24/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    
    // Settings for the AVAudioRecorder
    var recorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            try recordingSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            
        } catch {
            print("recordingSession ")
        }
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy mm dd hh ss"
        let filename = dateFormatter.string(from: date)
        let fileUrl = documentURL.appendingPathComponent(filename)
        
        do {
            recorder = try AVAudioRecorder(url: fileUrl, settings: [AVFormatIDKey:Int(kAudioFormatMPEG4AAC), AVSampleRateKey:44100.0, AVNumberOfChannelsKey:2])
        } catch {
            print("Failed to set up AVAudioRecorder")
            print(error)
        }
        recorder.prepareToRecord()
        
    }
    
    @IBAction func pressRecordButton(_ sender: UIButton) {
        if !sender.isSelected {
            // start recording
            recorder.record()
            sender.isSelected = true
            playbackButtonState.isEnabled = false
            timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [weak self] (timer) in
                guard let strong_self = self else {
                    return
                }
                if strong_self.recorder.isRecording {
                    strong_self.counterLabel.text = String(format: "%.02f", strong_self.recorder.currentTime)
                } else {
                    timer.invalidate()
                }
                })
        } else {
            //stop recording
            recorder.stop()
            sender.isSelected = false
            playbackButtonState.isEnabled = true
        }
    }
    
    @IBAction func pressPlaybackButton(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            audioPlayer.delegate = self
            audioPlayer.play()
            print("Playing back file")
        } catch {
            print("Couldn't play back")
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBOutlet weak var playbackButtonState: UIButton!
    
    
    @IBOutlet weak var counterLabel: UILabel!
   
}

extension RecordingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("played, woo!")
            playbackButtonState.isSelected = false
        }
    }
}
