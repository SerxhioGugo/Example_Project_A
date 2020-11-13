//
//  SportsViewModel.swift
//  SportsBook_Prototype
//
//  Created by Serxhio Gugo on 11/9/20.
//
//
import UIKit
import WHSportsbook
import WHNetwork

protocol SportsDelegate: class {
    func updateUI()
}

enum Section: Hashable {
    case eventDate(string: String)
}

class SportsViewModel {

    weak var delegate: SportsDelegate? {
        didSet {
            loadSchedule()
        }
    }
    
    var expandedSection = -9 {
        didSet {
            if oldValue == expandedSection { expandedSection = -1 }
        }
    }
    
    var allDates = [Date]()
    private var allEvents = WHSportsbook.Events()
    
    func eventsArray(_ section: Int) -> WHSportsbook.Events {
        let groupedEvents = allEvents.groupedBy(dateComponents: [.month, .day]).sorted(by: { (ev1, ev2) -> Bool in return ev1.key < ev2.key })
        
        let sortedEvents = groupedEvents.compactMap({$0.value})[section].sorted { (ev1, ev2) -> Bool in
            return ev1.startTime < ev2.startTime
        }
        return section == expandedSection ? sortedEvents : []
    }
 
}

extension SportsViewModel: WHJsonRequestable {
    
    func loadSchedule() {
        guard let url = APIManager.requestType(.getScheduleEventForSportId(id: "americanfootball")) else { return }
        decodeJsonDataFrom(url: url, objectType: WHSportsbook.Sport.self) { [weak self] (jsonObject, error) in
            guard let model = jsonObject, model.competitions.count > 0 else {
                if let err = error { print("eventsData request failed... error: \(err)\n") }
                return
            }
            
            let eventsResponse = model.competitions.compactMap({$0.events})
            let initial: WHSportsbook.Events = []
            let result = eventsResponse.reduce(into: initial) { acc, cur in
                acc.append(contentsOf: cur)
            }
            let groupedEvents = result.groupedBy(dateComponents: [.month, .day]).sorted(by: { (ev1, ev2) -> Bool in return ev1.key < ev2.key })
            self?.allDates = groupedEvents.compactMap({$0.key}).sorted()
            self?.allEvents = result
            self?.delegate?.updateUI()
            
        }
    }
    
}
