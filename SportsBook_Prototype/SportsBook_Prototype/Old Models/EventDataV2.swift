//
//  EventDataV2.swift
//  iOS
//
//  Created by Daniel Tepper on 9/16/20.
//

// NOTES:
//   for sport specific endpoints, eg /v2/sports/{sportId}/events/schedule use EventDataV2 model
//   for non-sport specific endpoints, eg /v2/events/highlights use EventDataV2Array model

import Foundation

// MARK: - EVENT_DATA_V2 MODEL

public struct EventDataV2: Codable, Identifiable {
    
    static let `default` = EventDataV2(sportId: "N/A", name: "N/A", eventCount: 10, competitions: [Competition]())
    
    public var id: String { sportId }
    public let sportId: String
    public let name: String
    public let eventCount: Int
    public let competitions: [Competition]
    
    public struct Competition: Codable, Identifiable {
        
        public let id: String
        public let name: String
        public let groupName: String?
        public let events: [Event]
        
        public struct Event: Codable, Identifiable {
            
            public let id: String
            public let name: String
            public let startTime: Date
            public let type: String
            public let display: Bool
            public let tradedInPlay: Bool
            public let sportId: String
            public let competitionId: String
            public let competitionName: String
            public let active: Bool
            public let started: Bool
            public let marketCountActivePreMatch: Int
            public let marketCountActiveInPlay: Int
            public let markets: [Market]
            
            public struct Market: Codable {
                
                public let id: String?
                public let name: String?
                public let displayOrder: Int
                public let type: String?
                public let display: Bool
                public let tradedInPlay: Bool
                public let templateId: String?
                public let spOffered: Bool
                public let active: Bool
                public let sportId: String?
                public let competitionId: String?
                public let eventId: String?
                public let displayName: String?
                public let collectionName: String
                public let primaryDisplayOrder: Int
                public let secondaryDisplayOrder: Int
                public let sixPackView: Bool
                public let line: Double?
                public let selections: [Selection]
                
                public struct Selection: Codable, Identifiable {
                    
                    public let id: String
                    public let display: Bool
                    public let name: String
                    public let sportId: String
                    public let competitionId: String
                    public let eventId: String
                    public let marketId: String
                    public let active: Bool
                    public let type: String
                    public let price: Price?
                    
                    public struct Price: Codable {
                        
                        public let f: String
                        public let d: Double
                        public let a: Int
                        
                        public init() {
                            f = ""
                            d = 0.0
                            a = 0
                        }
                    }
                }
            }
        }
    }
}

// used for "highlights" which is an array of V2 EventData
public typealias EventDataV2Array = [EventDataV2]

// MARK: - COMPUTED PROPERTIES

extension EventDataV2 {
    
    public var logoImage: String {
        return name.lowercased()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "")
    }
    
    static func getCompetitionsForSport(v2DataArray: EventDataV2Array, sportId: String) -> [EventDataV2.Competition] {
        for eventData in v2DataArray {
            if eventData.sportId == sportId {
                return eventData.competitions
            }
        }
        return [EventDataV2.Competition]()
    }
}

extension EventDataV2.Competition.Event {
    
    public var selections: [EventDataV2.Competition.Event.Market.Selection] {
        if let market = markets.first {
            return market.selections
        }
        return [EventDataV2.Competition.Event.Market.Selection]()
    }
    
    public var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d | h:mm a"
        return "\(dateFormatter.string(from: startTime)) \(TimeZone.current.abbreviation() ?? "")"
    }
}

extension EventDataV2.Competition.Event.Market.Selection {
    
    public var logoImage: String {
        switch sportId {
        case "tennis":
            return "blank"
        case "golf":
            return "blank"
        case "ufcmma":
            return "blank"
        default:
            return name.lowercased()
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: " ", with: "_")
                .replacingOccurrences(of: ".", with: "")
        }
    }
}

extension EventDataV2.Competition.Event.Market.Selection.Price {
    
    public var americanOdds: String {
        let sign = self.a >= 0 ? "+" : "-"
        return "\(sign)\(abs(self.a))"
    }
}

// MARK: - CUSTOM INITIALIZERS (ALSO FOR DEBUGGING)

extension EventDataV2 {
        
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)

        do {
            sportId = try container.decode(String.self, forKey: .sportId)
        } catch let error {
            print("EventsSchedule.sportId: \(error.localizedDescription)")
            sportId = "Error"
        }

        do {
            name = try container.decode(String.self, forKey: .name)
        } catch let error {
            print("EventsSchedule.name: \(error.localizedDescription)")
            name = "Error"
        }

        do {
            eventCount = try container.decode(Int.self, forKey: .eventCount)
        } catch let error {
            print("EventsSchedule.eventCount: \(error.localizedDescription)")
            eventCount = -1
        }

        do {
            competitions = try container.decode([Competition].self, forKey: .competitions)
        } catch let error {
            print("EventsSchedule.competitions: \(error.localizedDescription)")
            competitions = []
        }
    }
}

extension EventDataV2.Competition {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)

        do {
            id = try container.decode(String.self, forKey: .id)
        } catch let error {
            print("EventsSchedule.Competition.id: \(error.localizedDescription)")
            id = "Error"
        }

        do {
            name = try container.decode(String.self, forKey: .name)
        } catch let error {
            print("EventsSchedule.Competition.name: \(error.localizedDescription)")
            name = "Error"
        }

        do {
            groupName = try container.decodeIfPresent(String.self, forKey: .groupName)
        } catch let error {
            print("EventsSchedule.Competition.groupName: \(error.localizedDescription)")
            groupName = "Error"
        }

        do {
            events = try container.decode([Event].self, forKey: .events)
        } catch let error {
            print("EventsSchedule.Competition.events: \(error.localizedDescription)")
            events = []
        }
    }
}

extension EventDataV2.Competition.Event {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)

        do {
            id = try container.decode(String.self, forKey: .id)
        } catch let error {
            print("EventsSchedule.Competition.Event.id: \(error.localizedDescription)")
            id = "Error"
        }

        do {
            name = try container.decode(String.self, forKey: .name)
        } catch let error {
            print("EventsSchedule.Competition.Event.name: \(error.localizedDescription)")
            name = "Error"
        }

        do {
            let dateFormatter = DateFormatter()
            let stringDate = try container.decode(String.self, forKey: .startTime)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
            startTime = dateFormatter.date(from: stringDate) ?? Date()
        } catch let error {
            print("EventsSchedule.Competition.Event.startTime: \(error.localizedDescription)")
            startTime = Date()
        }

        do {
            type = try container.decode(String.self, forKey: .type)
        } catch let error {
            print("EventsSchedule.Competition.Event.type: \(error.localizedDescription)")
            type = "Error"
        }

        do {
            display = try container.decode(Bool.self, forKey: .display)
        } catch let error {
            print("EventsSchedule.Competition.Event.display: \(error.localizedDescription)")
            display = false
        }

        do {
            tradedInPlay = try container.decode(Bool.self, forKey: .tradedInPlay)
        } catch let error {
            print("EventsSchedule.Competition.Event.tradedInPlay: \(error.localizedDescription)")
            tradedInPlay = false
        }

        do {
            sportId = try container.decode(String.self, forKey: .sportId)
        } catch let error {
            print("EventsSchedule.Competition.Event.sportId: \(error.localizedDescription)")
            sportId = "Error"
        }

        do {
            competitionId = try container.decode(String.self, forKey: .competitionId)
        } catch let error {
            print("EventsSchedule.Competition.Event.competitionId: \(error.localizedDescription)")
            competitionId = "Error"
        }

        do {
            competitionName = try container.decode(String.self, forKey: .competitionName)
        } catch let error {
            print("EventsSchedule.Competition.Event.competitionName: \(error.localizedDescription)")
            competitionName = "Error"
        }

        do {
            active = try container.decode(Bool.self, forKey: .active)
        } catch let error {
            print("EventsSchedule.Competition.Event.active: \(error.localizedDescription)")
            active = false
        }

        do {
            started = try container.decode(Bool.self, forKey: .started)
        } catch let error {
            print("EventsSchedule.Competition.Event.started: \(error.localizedDescription)")
            started = false
        }

        do {
            marketCountActivePreMatch = try container.decode(Int.self, forKey: .marketCountActivePreMatch)
        } catch let error {
            print("EventsSchedule.Competition.Event.marketCountActivePreMatch: \(error.localizedDescription)")
            marketCountActivePreMatch = -1
        }

        do {
            marketCountActiveInPlay = try container.decode(Int.self, forKey: .marketCountActiveInPlay)
        } catch let error {
            print("EventsSchedule.Competition.Event.marketCountActiveInPlay: \(error.localizedDescription)")
            marketCountActiveInPlay = -1
        }

        do {
            markets = try container.decode([Market].self, forKey: .markets)
        } catch let error {
            print("EventsSchedule.Competition.markets: \(error.localizedDescription)")
            markets = []
        }
    }
}

extension EventDataV2.Competition.Event.Market {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)

        do {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.id: \(error.localizedDescription)")
            id = "Error"
        }

        do {
            name = try container.decodeIfPresent(String.self, forKey: .name)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.name: \(error.localizedDescription)")
            name = "Error"
        }
        
        do {
            displayOrder = try container.decode(Int.self, forKey: .displayOrder)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.displayOrder: \(error.localizedDescription)")
            displayOrder = -1
        }
        
        do {
            type = try container.decodeIfPresent(String.self, forKey: .type)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.type: \(error.localizedDescription)")
            type = "Error"
        }

        do {
            display = try container.decode(Bool.self, forKey: .display)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.display: \(error.localizedDescription)")
            display = false
        }

        do {
            tradedInPlay = try container.decode(Bool.self, forKey: .tradedInPlay)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.tradedInPlay: \(error.localizedDescription)")
            tradedInPlay = false
        }
        
        do {
            templateId = try container.decodeIfPresent(String.self, forKey: .templateId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.templateId: \(error.localizedDescription)")
            templateId = "Error"
        }

        do {
            spOffered = try container.decode(Bool.self, forKey: .spOffered)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.spOffered: \(error.localizedDescription)")
            spOffered = false
        }

        do {
            active = try container.decode(Bool.self, forKey: .active)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.active: \(error.localizedDescription)")
            active = false
        }

        do {
            sportId = try container.decodeIfPresent(String.self, forKey: .sportId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.sportId: \(error.localizedDescription)")
            sportId = "Error"
        }

        do {
            competitionId = try container.decodeIfPresent(String.self, forKey: .competitionId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.competitionId: \(error.localizedDescription)")
            competitionId = "Error"
        }

        do {
            eventId = try container.decodeIfPresent(String.self, forKey: .eventId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.eventId: \(error.localizedDescription)")
            eventId = "Error"
        }

        do {
            displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.displayName: \(error.localizedDescription)")
            displayName = "Error"
        }
        
        do {
            collectionName = try container.decode(String.self, forKey: .collectionName)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.collectionName: \(error.localizedDescription)")
            collectionName = "Error"
        }

        do {
            primaryDisplayOrder = try container.decode(Int.self, forKey: .primaryDisplayOrder)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.primaryDisplayOrder: \(error.localizedDescription)")
            primaryDisplayOrder = -1
        }

        do {
            secondaryDisplayOrder = try container.decode(Int.self, forKey: .secondaryDisplayOrder)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.secondaryDisplayOrder: \(error.localizedDescription)")
            secondaryDisplayOrder = -1
        }

        do {
            sixPackView = try container.decode(Bool.self, forKey: .sixPackView)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.sixPackView: \(error.localizedDescription)")
            sixPackView = false
        }

        do {
            line = try container.decodeIfPresent(Double.self, forKey: .line)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.line: \(error.localizedDescription)")
            line = 0.0
        }

        do {
            selections = try container.decode([Selection].self, forKey: .selections)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.selections: \(error.localizedDescription)")
            selections = []
        }
    }
}

extension EventDataV2.Competition.Event.Market.Selection {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.id: \(error.localizedDescription)")
            id = "Error"
        }
        
        do {
            display = try container.decode(Bool.self, forKey: .display)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.display: \(error.localizedDescription)")
            display = false
        }
        
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.name: \(error.localizedDescription)")
            name = "Error"
        }

        do {
            sportId = try container.decode(String.self, forKey: .sportId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.sportId: \(error.localizedDescription)")
            sportId = "Error"
        }
        
        do {
            competitionId = try container.decode(String.self, forKey: .competitionId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.competitionId: \(error.localizedDescription)")
            competitionId = "Error"
        }
        
        do {
            eventId = try container.decode(String.self, forKey: .eventId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.eventId: \(error.localizedDescription)")
            eventId = "Error"
        }
        
        do {
            marketId = try container.decode(String.self, forKey: .marketId)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.marketId: \(error.localizedDescription)")
            marketId = "Error"
        }

        do {
            active = try container.decode(Bool.self, forKey: .active)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.active: \(error.localizedDescription)")
            active = false
        }

        do {
            type = try container.decode(String.self, forKey: .type)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.type: \(error.localizedDescription)")
            type = "Error"
        }

        do {
            price = try container.decodeIfPresent(Price.self, forKey: .price)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.price: \(error.localizedDescription)")
            price = Price()
        }
    }
}

extension EventDataV2.Competition.Event.Market.Selection.Price {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)

        do {
            f = try container.decode(String.self, forKey: .f)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.Price.f: \(error.localizedDescription)")
            f = "Error"
        }

        do {
            d = try container.decode(Double.self, forKey: .d)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.Price.d: \(error.localizedDescription)")
            d = 0.0
        }

        do {
            a = try container.decode(Int.self, forKey: .a)
        } catch let error {
            print("EventsSchedule.Competition.Event.Market.Selection.Price.a: \(error.localizedDescription)")
            a = 0
        }
    }
}
