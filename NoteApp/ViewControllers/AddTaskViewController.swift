//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Han on 2024/10/2.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    var addTask: ((String) -> Void)?
    let textField = PaddingTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Add Task"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Enter task name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 14
        textField.layer.borderWidth = 1
        
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Add"
        config.baseForegroundColor = .black
        config.baseBackgroundColor = UIColor(cgColor: CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        addButton.configuration = config
        addButton.layer.cornerRadius = 14
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, addButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc private func onClick() {
        // 取得 textField 的輸入值
        guard let taskName = textField.text, !taskName.isEmpty else {
            // 可以在這裡處理空值，例如顯示提示
            print("Please enter a task name.")
            return
        }
        
        // 使用 addTask 閉包傳遞輸入的值
        addTask?(taskName)
        // 可選：關閉視圖控制器
        dismiss(animated: true, completion: nil)
    }
}

class PaddingTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // 控制 placeholder 和非編輯狀態時的內邊距
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }

        // 控制正在編輯狀態時的內邊距
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }
        
        // 控制 placeholder 的內邊距
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
        }
}

#Preview {
    UINavigationController(rootViewController: AddTaskViewController())
}
