//
//  PostTableViewCell.swift
//  gmoni
//
//  Created by 大矢政行 on 2020/05/20.
//  Copyright © 2020 masayuki.ohya. All rights reserved.
//

import UIKit
import FirebaseUI
import AVFoundation

class PostTableViewCell: UITableViewCell, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    var isPlaying = false
    
    var voiceURL = URL(fileURLWithPath: voicepath)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setPostData(_ postData: PostData) {
        
        let voiceRef = Storage.storage().reference().child(Const.VoicePath).child(postData.id + ".m4a")
        let voicepath = voiceRef.fullPath;

        self.accountLabel.text = "\(postData.name!)"
        self.captionLabel.text = "\(postData.caption!)"

        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if !isPlaying {
            audioPlayer = try! AVAudioPlayer(contentsOf: voiceURL)
            audioPlayer.delegate = self
            audioPlayer.play()
            audioPlayer.volume = 2.0
            isPlaying = true
        }else{
            audioPlayer.stop()
            isPlaying = false
        }
    }
    
}
