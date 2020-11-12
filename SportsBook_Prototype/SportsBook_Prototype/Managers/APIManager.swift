//
//  APIManager.swift
//  LiveMatches
//
//  Created by Serxhio Gugo on 10/1/20.
//

import Foundation
import Combine

struct APIManager {
    
    public enum GET {
        case getAllSports
        case getAllPopular
        case getInPlayEventsForSportId(id: String)
        case getScheduleEventForSportId(id: String)
    }
    
    static func requestType(_ request: GET) -> URL? {
        let urlString: String
        
        switch request {
        
        case .getAllSports:
            urlString = "https://s3.amazonaws.com/skunkworks.nj.us.prototype.data/json/sportIds.json"
            
        case .getAllPopular:
            urlString = "https://s3.amazonaws.com/skunkworks.nj.us.prototype.data/json/sportIds.json"
            
        case .getInPlayEventsForSportId(let id):
//            urlString = "http://localhost:8083/api/v2/sports/\(id)/events/in-play"
            urlString = "https://s3.amazonaws.com/skunkworks.nj.us.prototype.data/json/sportsbook/api/v2_sports_\(id)_events_in-play.json"
        case .getScheduleEventForSportId(let id):
//            urlString = "http://MBP-MDIMO-USNJ.local/api/v2/sports/\(id)/events/schedule"
//            urlString = "http://USNJ-MDIMO-MBP.local:8083/api/v2/sports/\(id)/events/schedule"
//            urlString = "http://localhost:8083/api/v2/sports/\(id)/events/schedule"
            urlString = "https://s3.amazonaws.com/skunkworks.nj.us.prototype.data/json/sportsbook/api/v2_sports_\(id)_events_schedule.json"
        }
        print("\n\t url: \(urlString)\n")
        return URL(string: urlString)
    }
    
    static func fetch<T: Codable>(url: URL, completion: @escaping (T?, Error?) -> Void) {
        let decoder = JSONDecoder()
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("🚀 DEBUG: Error fetching data: ", error)
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode > 200 {
                    print("🚀 DEBUG: Bad response from server: Response: \(httpResponse), Status Code: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else { return }
            
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(object, nil)
            } catch let jsonError {
                print("🚀 DEBUG: Error decoding data: ", jsonError)
                completion(nil, jsonError)
                return
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Fetching using combine
    static func fetchCombine<T: Decodable>(_ url: URL, defaultValue: T) -> AnyPublisher<T, Never> {
        let decoder = JSONDecoder()
        
        return URLSession.shared.dataTaskPublisher(for: url)
            //            .delay(for: .seconds(Double.random(in: 1...5)), scheduler: RunLoop.main)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
