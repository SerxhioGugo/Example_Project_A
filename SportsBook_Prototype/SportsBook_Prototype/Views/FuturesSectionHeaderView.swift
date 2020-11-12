//
//  FuturesSectionHeaderView.swift
//  SportsBook_Prototype
//
//  Created by Michael Dimore on 11/6/20.
//

import UIKit
import SnapKit

class FuturesSectionHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = String(describing: self)
    
    var label: UILabel
    
    override init(reuseIdentifier: String?) {
        
        label = UILabel(frame: .zero)
//        super.init(reuseIdentifier: String(describing: type(of: FuturesSectionHeaderView.self)))
        super.init(reuseIdentifier: String(describing: type(of: Self.self)))
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.backgroundColor = .clear
        contentView.addSubview(label)
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.widthAnchor.constraint(equalToConstant: 240.0).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
//        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        label.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

// MARK: - Header view configuration

extension FuturesSectionHeaderView {
    func setupHeaderLabel(_ text: String) {
        label.text = text
    }
}
