//
//  PostViewController.swift
//  gmoni
//
//  Created by 大矢政行 on 2020/05/06.
//  Copyright © 2020 masayuki.ohya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import AVFoundation

class PostViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var demoplayButton: UIButton!
    
    let data = Data()
    
    var audioPlayer: AVAudioPlayer!
    var isPlaying = false
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    @IBAction func demoplayButtonTapped(_ sender: Any) {
        if !isPlaying {
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            audioPlayer.volume = 2.0
            isPlaying = true
        }else{
            audioPlayer.stop()
            isPlaying = false
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.demoplayButtonTapped(demoplayButton)
    }
    
    @IBAction func handlePostButton(_ sender: Any) {
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let voiceRef = Storage.storage().reference().child(Const.VoicePath).child(postRef.documentID + ".m4a")
        
        SVProgressHUD.show()
        
        let metadata = StorageMetadata()
        metadata.contentType = "voice/m4a"
        voiceRef.putData(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "アップロードが失敗しました")
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            if let Caption = self.textField.text {
                if Caption.isEmpty {
                    SVProgressHUD.showError(withStatus: "投稿内容を入力して下さい")
                    return
                }
            }
        }
        
        let name = Auth.auth().currentUser?.displayName
         let postDic = [
             "name": name!,
             "caption": self.textField.text!,
             "date": FieldValue.serverTimestamp(),
             ] as [String : Any]
         postRef.setData(postDic)
         // HUDで投稿完了を表示する
         SVProgressHUD.showSuccess(withStatus: "投稿しました")
         // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        accountName.text = user?.displayName!
    }


}
