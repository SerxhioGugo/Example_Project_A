//
//  Date.swift
//  SportsBook_Prototype
//
//  Created by Serxhio Gugo on 11/9/20.
//

import UIKit

extension Date {
    var shortDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d | h:mma"
        return "\(dateFormatter.string(from: self))"
    }
}
