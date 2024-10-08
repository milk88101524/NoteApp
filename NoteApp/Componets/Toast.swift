//
//  Toast.swift
//  TodoList
//
//  Created by Han on 2024/10/8.
//

import UIKit

class Toast {
    class PaddedLabel: UILabel {
        
        // 設定 padding 大小
        var textInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        // 調整文字繪製的區域
        override func drawText(in rect: CGRect) {
            let insets = textInsets
            let insetRect = rect.inset(by: insets)
            super.drawText(in: insetRect)
        }
        
        // 調整 `intrinsicContentSize` 以反映 padding
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + textInsets.left + textInsets.right,
                          height: size.height + textInsets.top + textInsets.bottom)
        }
        
        // 調整當 frame 改變時的大小
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let sizeThatFits = super.sizeThatFits(size)
            return CGSize(width: sizeThatFits.width + textInsets.left + textInsets.right,
                          height: sizeThatFits.height + textInsets.top + textInsets.bottom)
        }
    }
    
    static func show(message: String, in view: UIView, duration: TimeInterval = 4.0) {
        let toastLabel = PaddedLabel()
        toastLabel.textInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .left
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        // 設定 toast 的大小
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastLabel)
        
        // 設定約束
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            toastLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toastLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        // 動畫消失
        UIView.animate(withDuration: duration, delay: 0.1, options: .autoreverse, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

