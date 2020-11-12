//
//  Array.swift
//  SportsBook_Prototype
//
//  Created by Serxhio Gugo on 11/5/20.
//

import Foundation
import WHSportsbook

extension Array where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.startTime)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        return groupedByDateComponents
    }
}
