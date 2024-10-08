//
//  Snackbar.swift
//  TodoList
//
//  Created by Han on 2024/10/8.
//

import UIKit

class Snackbar {
    static func show(message: String, in view: UIView, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        let snackbar = UIView()
        snackbar.backgroundColor = UIColor.black
        snackbar.alpha = 0.0
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        snackbar.addSubview(messageLabel)
        
        if let actionTitle = actionTitle {
            let actionButton = UIButton(type: .system)
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.addTarget(nil, action: #selector(snackbarActionTapped), for: .touchUpInside)
            snackbar.addSubview(actionButton)
            
            // 設定 action button 的位置
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10).isActive = true
            actionButton.trailingAnchor.constraint(equalTo: snackbar.trailingAnchor, constant: -10).isActive = true
            actionButton.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor).isActive = true
        }
        
        // 設定 messageLabel 的位置
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: snackbar.leadingAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: snackbar.trailingAnchor, constant: -10).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor).isActive = true
        
        view.addSubview(snackbar)
        
        // 設定 snackbar 的位置
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            snackbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            snackbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            snackbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            snackbar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 動畫出現
        UIView.animate(withDuration: 0.5) {
            snackbar.alpha = 1.0
        }
        
        // 動畫消失
        UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
            snackbar.alpha = 0.0
        }, completion: { _ in
            snackbar.removeFromSuperview()
        })
    }
    
    @objc static func snackbarActionTapped() {
        // 執行 Snackbar 按鈕的操作
    }
}
