//
//  LogEvent.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-11-15.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import Foundation

enum LogEvent: Int16 {
    case ItemAdded
    case ItemUpdated
    case ItemDeleted
    case CategoryAdded
    case CategoryUpdated
    case CategoryDeleted
    case GuestLogin
    case AdminLogin
}
