//
//  ViewController.swift
//  LiveMatches
//
//  Created by Serxhio Gugo on 10/1/20.
//

import UIKit
import Combine
import WHSportsbook

class SportsViewController: UITableViewController {

    var allSports = [Popular]()
    
    let vm = SportsViewModel()

    var dataSource: UITableViewDiffableDataSource<Section, WHSportsbook.Event>? = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section,  WHSportsbook.Event>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(FuturesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: FuturesSectionHeaderView.reuseIdentifier )
        self.title = "All Sports"
        configureDataSource()
    }
    
    //Configure data source and cell
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, event) -> UITableViewCell? in            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = event.name.replacingOccurrences(of: "|", with: "")
            return cell
        })
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FuturesSectionHeaderView.reuseIdentifier) as? FuturesSectionHeaderView else { return UIView() }
        header.setupHeaderLabel(vm.allDates[section].shortDateString)
        header.tag = section
        let tappedHeader = UITapGestureRecognizer(target: self, action: Selector("tappedHeader:"))
        header.addGestureRecognizer(tappedHeader)
        print("\n\n\t section: \(section)\n\n")
        return header
    }
    
    @objc func tappedHeader(_ sender: UIGestureRecognizer) {
        vm.expandedSection = sender.view?.tag ?? -9
        updateUI()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - DidSelect handler w/ diffable
extension SportsViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = dataSource?.itemIdentifier(for: indexPath) else { return }
        let singleSportController = SingleSportController(sportId: event.sportId)
        singleSportController.title = event.eventName
        self.navigationController?.pushViewController(singleSportController, animated: true)
    }
}

// MARK: - Networking functions
extension SportsViewController: SportsDelegate {
    
    //Update UI by feeding the data
    func updateUI() {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section,  WHSportsbook.Event>()
            for (idx, date) in self.vm.allDates.enumerated() {
                snapshot.appendSections([.eventDate(string: date.shortDateString)])
                snapshot.appendItems(self.vm.eventsArray(idx))
                self.dataSource?.apply(snapshot, animatingDifferences: true)
            }
        }
    }
}
