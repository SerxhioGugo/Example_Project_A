//
//  Float.swift
//  PTypeV2
//
//  Created by Daniel Tepper on 8/17/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import Foundation

extension Float {
    var dollars: String {
        return String(format: "$%.2f", self)
    }
}

extension Double {
    var dollars: String {
        return String(format: "$%.2f", self)
    }
    
    var spread: String {
        let prefix = self >= 0 ? "+" : "-"
        return String(format: "%@%.1f", prefix, abs(self))
    }
}
