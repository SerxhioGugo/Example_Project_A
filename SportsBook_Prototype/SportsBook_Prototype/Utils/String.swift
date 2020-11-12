//
//  String.swift
//  PTypeV2
//
//  Created by Daniel Tepper on 7/21/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import Foundation

extension String {

    //
    // convert camel-case names to words eg. for display labels
    //
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1))
                }
            }
            return $0 + String($1)
        }
    }
    
    var floatValue: Float {
        if let fltValue = Float(self) {
            return fltValue
        }
        return 0.0
    }
    
    var doubleValue: Double {
        if let dblValue = Double(self) {
            return dblValue
        }
        return 0.0
    }
    
    var currencyString: String {
        String(format: "$%.2f", doubleValue)
    }
}
