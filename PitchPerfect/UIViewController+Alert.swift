//
//  UIViewController+Alert.swift
//  PitchPerfect
//
//  Created by Eduardo Costa on 19/09/16.
//  Copyright © 2016 Mobaly. All rights reserved.
//

import UIKit

extension UIViewController {
    
    struct Alert {
        let title: String
        let message: String
        let animated: Bool
        
        init(title: String, message: String, animated: Bool = true) {
            self.title = title
            self.message = message
            self.animated = animated
        }
    }
    
    func showAlert(_ alert: Alert, dismissHandler handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController  = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(makeDismissAction(handler))
        
        self.present(alertController, animated: alert.animated, completion: nil)
    }
    
    func makeDismissAction(_ handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: AlertActions.Dismiss, style: .default, handler: handler)
    }
}
