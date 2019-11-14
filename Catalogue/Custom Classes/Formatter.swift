//
//  NumberFormatter.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-11-13.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import Foundation

class Formatter {
    
    let format: NumberFormatter
    
    init(minDecimalPlaces: Int, maxDecimalPlaces: Int) {
        self.format =  {
               let f = NumberFormatter()
               f.numberStyle = .decimal
               f.minimumFractionDigits = minDecimalPlaces
               f.maximumFractionDigits = maxDecimalPlaces
               return f
           }()
    }
    
    
}
