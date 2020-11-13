//
//  SingleSportController.swift
//  LiveMatches
//
//  Created by Serxhio Gugo on 10/1/20.
//

import UIKit
import SnapKit

class SingleSportController: UITableViewController {
    
    let ac: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(style: .large)
        ac.backgroundColor = .darkGray
        ac.startAnimating()
        return ac
    }()
    
    var sport = [EventDataV2.Competition]()
    
    let id: String
    
    init(sportId: String) {
        self.id = sportId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(ac)
        ac.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        print("🚀 DEBUG: ID FROM SINGLE SPORT CONTROLLER \(id)")
        tableView.register(SelectionsCell.self, forCellReuseIdentifier: "singleSportId")
        guard let url = APIManager.requestType(.getScheduleEventForSportId(id: self.id)) else { return }
        APIManager.fetch(url: url) { (request: EventDataV2?, error) in
            guard let competitions = request else { return }
            let data = EventDataV2.getCompetitionsForSport(v2DataArray: [competitions], sportId: self.id)
            
            DispatchQueue.main.async {
                self.sport = data
                self.tableView.reloadData()
                self.ac.stopAnimating()
            }
        }
    }
    
}

extension SingleSportController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleSportId", for: indexPath) as! SelectionsCell

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionName = sport[section].name
//
//        return sectionName
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
