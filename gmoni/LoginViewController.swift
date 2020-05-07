//
//  LoginViewController.swift
//  gmoni
//
//  Created by 大矢政行 on 2020/05/06.
//  Copyright © 2020 masayuki.ohya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
        if address.isEmpty || password.isEmpty {
            SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
            return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ログインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {

        if address.isEmpty || password.isEmpty || displayName.isEmpty {
            print("DEBUG_PRINT: 入力されていない項目があります")
            SVProgressHUD.showError(withStatus: "項目を入力して下さい")
            return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "アカウント作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: アカウント作成に成功しました。")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
