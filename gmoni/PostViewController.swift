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

class PostViewController: UIViewController {
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func demoplayButton(_ sender: Any) {
    }
    
    @IBAction func handlePostButton(_ sender: Any) {
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        SVProgressHUD.show()
        
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
    }


}
