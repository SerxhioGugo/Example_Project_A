//
//  SelectionsCell.swift
//  LiveMatches
//
//  Created by Serxhio Gugo on 10/2/20.
//

import UIKit
import SnapKit

class SelectionsCell: UITableViewCell {


    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.text = "Something"
        label.numberOfLines = 1
        return label
    }()
    
    let homeTeamLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let awayTeamLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var teamsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var sixPackMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var marketTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(spread)
        stackView.addArrangedSubview(moneyLine)
        stackView.addArrangedSubview(totalRuns)
        return stackView
    }()
    
    let moneyLine = WHPrimaryLabel(title: "Money Line", color: .darkGray, size: 8, textAlign: .center, borderWidth: 0, borderColor: UIColor.clear.cgColor)
    let spread = WHPrimaryLabel(title: "Spread", color: .darkGray, size: 8, textAlign: .center, borderWidth: 0, borderColor: UIColor.clear.cgColor)
    let totalRuns = WHPrimaryLabel(title: "Total Runs", color: .darkGray, size: 8,  textAlign: .center, borderWidth: 0, borderColor: UIColor.clear.cgColor)
    let numberLabel1 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.9136391878, green: 0.9373081326, blue: 0.968511641, alpha: 1), size: 12, textAlign: .center)
    let numberLabel2 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.8352089524, green: 0.878482461, blue: 0.9449841976, alpha: 0.5), size: 12, textAlign: .center)
    let numberLabel3 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.8352089524, green: 0.878482461, blue: 0.9449841976, alpha: 0.5), size: 12, textAlign: .center)
    let numberLabel4 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.8352089524, green: 0.878482461, blue: 0.9449841976, alpha: 0.5), size: 12, textAlign: .center)
    let numberLabel5 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.8352089524, green: 0.878482461, blue: 0.9449841976, alpha: 0.5), size: 12, textAlign: .center)
    let numberLabel6 = WHPrimaryLabel(title: "0", color: .black, backgroundColor: #colorLiteral(red: 0.8352089524, green: 0.878482461, blue: 0.9449841976, alpha: 0.5), size: 12, textAlign: .center)
    
    lazy var topMarketStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(numberLabel1)
        stackView.addArrangedSubview(numberLabel2)
        stackView.addArrangedSubview(numberLabel3)
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var bottomMarketStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(numberLabel4)
        stackView.addArrangedSubview(numberLabel5)
        stackView.addArrangedSubview(numberLabel6)
        stackView.spacing = 3
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Time
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(12)
        }
        // Home/Away Teams
        addSubview(teamsStackView)
        teamsStackView.addArrangedSubview(homeTeamLabel)
        teamsStackView.addArrangedSubview(awayTeamLabel)
        
        teamsStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(self.frame.width / 2)
        }
        
        addSubview(marketTitleStackView)
        marketTitleStackView.snp.makeConstraints { make in
            make.leading.equalTo(teamsStackView.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(20)
            make.height.equalTo(15)
        }
        
        addSubview(sixPackMainStackView)
        sixPackMainStackView.addArrangedSubview(topMarketStackView)
        sixPackMainStackView.addArrangedSubview(bottomMarketStackView)
        sixPackMainStackView.snp.makeConstraints { make in
            make.top.equalTo(marketTitleStackView.snp.bottom)
            make.leading.equalTo(teamsStackView.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class WHPrimaryLabel: UILabel {
    
    init(title: String = "Default",
         color: UIColor = .black,
         backgroundColor: UIColor = .white,
         size: CGFloat = 6,
         frame: CGRect = .zero,
         textAlign: NSTextAlignment = .center,
         borderWidth: CGFloat = 1,
         borderColor: CGColor = #colorLiteral(red: 0.3769620061, green: 0.5237457156, blue: 0.7763803601, alpha: 1).cgColor) {
        
        super.init(frame: frame)
        self.text = title
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size)
        self.textAlignment = textAlign
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
