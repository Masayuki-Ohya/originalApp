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
    
    @IBOutlet weak var timerMinute: UILabel!
    @IBOutlet weak var timerSecond: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var nextviewButton: UIButton!
    
    var timer: Timer!
    var timer_sec: Float = 0
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    @objc func timerCounter() {
        self.timer_sec += 1.0
        let minute = (Int)(fmod((timer_sec/60), 60))
        let second = (Int)(fmod(timer_sec, 60))
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        timerMinute.text = sMinute
        timerSecond.text = sSecond
    }
    
    var w: CGFloat = 0
    var h: CGFloat = 0
    let d: CGFloat = 50
    let l: CGFloat = 28
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var outerCircle: UIView!
    @IBOutlet weak var innerCircle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        w = baseView.frame.size.width
        h = baseView.frame.size.height
        initRoundCorners()
        showStartButton()
        playButton.isEnabled = false
        restartButton.isEnabled = false
        nextviewButton.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if !isRecording {
            if self.timer == nil {
                timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(self.timerCounter),
                userInfo: nil,
                repeats: true)
            }
            
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
            statusLabel.text = "録音中"
            playButton.isEnabled = false
            restartButton.isEnabled = false
            nextviewButton.isHidden = true
            
            UIView.animate(withDuration: 0.2) {
                self.showStopButton()
            }
            
        } else {
            if self.timer != nil {
                self.timer.invalidate()
                self.timer = nil
            }
            
            audioRecorder.stop()
            isRecording = false
            statusLabel.text = "録音終了"
            recordButton.isEnabled = false
            playButton.isEnabled = true
            restartButton.isEnabled = true
            nextviewButton.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.showStartButton()
            }
            
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        if !isPlaying {
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            audioPlayer.volume = 10.0
            isPlaying = true
            statusLabel.text = "再生中"
            recordButton.isEnabled = false
            restartButton.isEnabled = false
            nextviewButton.isHidden = true
            
            let buttonImage = UIImage(named: "stop_button")
            self.playButton.setImage(buttonImage, for: .normal)

        }else{
            audioPlayer.pause()
            isPlaying = false
            statusLabel.text = "待機中"
            recordButton.isEnabled = false
            restartButton.isEnabled = true
            
            let buttonImage = UIImage(named: "play_button")
            self.playButton.setImage(buttonImage, for: .normal)
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        let alert : UIAlertController = UIAlertController(title: nil, message: "録り直しますか？", preferredStyle:  UIAlertController.Style.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "録り直す", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.resetView()
        })
    
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextviewButtonTapped(_ sender: Any) {
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        self.present(postViewController, animated: true, completion: nil)
    }
    
    func resetView(){
        statusLabel.text = "ボタンをタップして\n録音してください"
        audioRecorder.stop()
        timer_sec = 0
        timerMinute.text = "00"
        timerSecond.text = "00"
        recordButton.isEnabled = true
        playButton.isEnabled = false
        restartButton.isEnabled = false
        nextviewButton.isHidden = true
    }
    
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playButtonTapped(playButton)
        statusLabel.text = "再生終了"
        nextviewButton.isHidden = false
    }
    
    
    func initRoundCorners(){
        recordButton.layer.masksToBounds = true
        
        baseView.layer.masksToBounds = true
        baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        outerCircle.layer.masksToBounds = true
        outerCircle.layer.cornerRadius = 31
        innerCircle.layer.masksToBounds = true
        innerCircle.layer.cornerRadius = 29
        
    }
    
    func showStartButton() {
        recordButton.frame = CGRect(x:(w-d)/2,y:(h-d)/2,width:d,height:d)
        recordButton.layer.cornerRadius = d/2
    }
    
    func showStopButton() {
        recordButton.frame = CGRect(x:(w-l)/2,y:(h-l)/2,width:l,height:l)
        recordButton.layer.cornerRadius = 3.0
    }

}
