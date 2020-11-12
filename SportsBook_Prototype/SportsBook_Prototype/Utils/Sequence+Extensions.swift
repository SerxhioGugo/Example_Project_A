//
//  Sequence+Extensions.swift
//  PTypeV2
//
//  Created by Michael Dimore on 10/7/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
