//
//  NoteTableViewCell.swift
//  TodoList
//
//  Created by Han on 2024/10/7.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var dateTitle: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.frame.size.height = 120
        
        titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateTitle = UILabel()
        dateTitle.text = "YYYY / MM / DD HH:mm:ss"
        dateTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let dateStackView = UIStackView(arrangedSubviews: [dateTitle])
        dateStackView.axis = .vertical
        dateStackView.spacing = 20
        dateStackView.alignment = .center
        dateStackView.distribution = .fill
        dateStackView.backgroundColor = UIColor(cgColor: CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        dateStackView.layer.cornerRadius = 14
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.isLayoutMarginsRelativeArrangement = true
        dateStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel])
        mainStackView.frame.size.width = .infinity
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.layer.cornerRadius = 14
        mainStackView.backgroundColor = UIColor(cgColor: CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        
        let dateShadowView = UIView()
        dateShadowView.translatesAutoresizingMaskIntoConstraints = false
        dateShadowView.layer.shadowColor = UIColor.black.cgColor
        dateShadowView.layer.shadowOpacity = 0.3
        dateShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        dateShadowView.layer.shadowRadius = 5
        dateShadowView.layer.cornerRadius = 14
        dateShadowView.backgroundColor = .clear
        dateShadowView.addSubview(dateStackView)
        
        contentView.addSubview(mainStackView)
        contentView.addSubview(dateShadowView)
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: dateShadowView.topAnchor, constant: 20),
            dateStackView.leadingAnchor.constraint(equalTo: dateShadowView.leadingAnchor, constant: 20),
            dateStackView.trailingAnchor.constraint(equalTo: dateShadowView.trailingAnchor, constant: -20),
            dateStackView.bottomAnchor.constraint(equalTo: dateShadowView.bottomAnchor, constant: -20),
            
            dateShadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateShadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor
                                                 )
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    NoteTableViewCell()
}
