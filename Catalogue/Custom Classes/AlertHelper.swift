//
//  AlertHelper.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-12-03.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    
    func displayAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .cancel)
        
        alert.addAction(okay)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
