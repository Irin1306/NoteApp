//
//  AlertService.swift
//  NoteApp
//
//  Created by USER on 09/10/2018.
//  Copyright © 2018 My. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    static func addAlert(in vc: UIViewController,
                         complition: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Photo", message: "Photo access is necessary to select photos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        // Add "OK" Button to alert, pressing it will bring you to the settings app
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            complition()
        }))
        // Show the alert with animation
        vc.present(alert, animated: true)
    }
    
}
