//
//  PaddingTextView.swift
//  TodoList
//
//  Created by Han on 2024/10/8.
//

import UIKit

class PaddingTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        
        layer.masksToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.5
    }
}
