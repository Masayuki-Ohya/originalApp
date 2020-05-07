//
//  AudioRecViewController.swift
//  gmoni
//
//  Created by 大矢政行 on 2020/05/06.
//  Copyright © 2020 masayuki.ohya. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var label: UILabel!
    
    @IBAction func recordButton(_ sender: Any) {
        if !isRecording {

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            isRecording = true

            label.text = "録音中"
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false

        }else{

            audioRecorder.stop()
            isRecording = false

            label.text = "待機中"
            recordButton.setTitle("RECORD", for: .normal)
            playButton.isEnabled = true

        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        if !isPlaying {

            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()

            isPlaying = true

            label.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false

        }else{

            audioPlayer.stop()
            isPlaying = false

            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true

        }
    }
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    

}
