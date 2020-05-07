//
//  TabBarController.swift
//  gmoni
//
//  Created by 大矢政行 on 2020/05/06.
//  Copyright © 2020 masayuki.ohya. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 46/255.0, green: 148/255.0, blue: 211/255.0, alpha: 1)
        self.delegate = self
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AudioRecViewController {
            let audioRecViewController = storyboard!.instantiateViewController(withIdentifier: "AudioRec")
            present(audioRecViewController, animated: true)
            return false
        } else {
            return true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }

}
