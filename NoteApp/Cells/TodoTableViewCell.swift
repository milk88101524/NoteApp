//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Han on 2024/10/1.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    var title: UILabel!
    var checkBox = CheckBox()
    
    var toggle: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = UIColor(cgColor: CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        
        title = UILabel()
        title.text = "Todo"
        title.translatesAutoresizingMaskIntoConstraints = false
        
        checkBox.checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        checkBox.checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let mainStackView = UIStackView(arrangedSubviews: [
            checkBox.checkBox,
            title,
        ])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            // MARK: auto layout - mainStackView
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkBoxTapped() {
        checkBox.isChecked.toggle()
        toggle?(checkBox.isChecked)
    }
}


#Preview {
    TodoTableViewCell()
}
