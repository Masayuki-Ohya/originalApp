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
    
    //時間表示関連ここから
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer!
    var timer_sec: Float = 0
    
    
    
    var isRecording = false
    
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
    }
    
    @objc func updateTimer(_ timer: Timer) {
        self.timer_sec += 1.0
        self.timerLabel.text = String(format: "%.0f", self.timer_sec)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        w = baseView.frame.size.width
        h = baseView.frame.size.height
        initRoundCorners()
        showStartButton()
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if isRecording {
            UIView.animate(withDuration: 0.2) {
                self.showStartButton()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.showStopButton()
            }
        }
        isRecording = !isRecording
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
        
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func showStopButton() {
        recordButton.frame = CGRect(x:(w-l)/2,y:(h-l)/2,width:l,height:l)
        recordButton.layer.cornerRadius = 3.0
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
        }
    }
    
}
