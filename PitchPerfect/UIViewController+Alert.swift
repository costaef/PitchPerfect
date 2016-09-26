//
//  UIViewController+Alert.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 19/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, animated: Bool = true) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(dismiss)
        
        self.present(alert, animated: animated, completion: nil)
    }
    
    var dismiss: UIAlertAction {
        return UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    }
}
